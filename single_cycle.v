// author: Guseul Heo
// start date: November 9, 2021
// end date: November 12, 2021

/* 
 * Challenge #3 :
 * Design the single-cycle stack machine
 */

module single_cycle(clk);
    parameter REG_BITS = 32; // 16 or 32

    input clk;
    wire [REG_BITS-1:0] instruction;
    
    wire [REG_BITS-1:0] PC_in, PC_out, PC, SP;
    wire [REG_BITS-1:0] stack_read1, stack_read2, operand2;
    wire [REG_BITS-1:0] data_read, ALUResult;

    wire [REG_BITS-1:0] stack_write_data;
    wire [REG_BITS-1:0] immediate; // sign extended immediate

    wire ALUOp;
    wire MemRead, MemWrite;
    wire [1:0] PCSrc; // 00: PC_temp, 01: branch, 10: pop_pc
    wire [1:0] StackWriteSrc; // 00: no write, 01: ALUresult, 10: dmem_read, 11: PC_temp
    wire ALUSrc; // 0: stack, 1: immediate
    wire [1:0] StackUpdateMode;
    wire branch;

    // fetch instrcution
    Instruction_Memory #(.REG_BITS(REG_BITS)) fetch_instr (
        .clk(clk), 
        .PC(PC_out), 
        .instruction(instruction)
    );

    // Control Program Counter
    Program_Counter #(.REG_BITS(REG_BITS)) pc_register (
        .clk(clk),
        .PC_in(PC_in), 
        .PC_out(PC_out)
    );

    PC_Adder #(.REG_BITS(REG_BITS)) pc_adder (
        .PC_in(PC_out), 
        .PC_out(PC)
    );

    MUX2 #(.REG_BITS(REG_BITS)) pc_mux (
        .s(branch), 
        .d0(PC), 
        .d1(stack_read1), 
        .out(PC_in)
    );

    // read top and next top data of stack
    Stack_Memory #(.REG_BITS(REG_BITS)) stack (
        .clk(clk), 
        .StackWrite(!(!StackWriteSrc)), 
        .SP(SP), 
        .write_data(stack_write_data), 
        .read1(stack_read1), 
        .read2(stack_read2)
    );
    
    // decode instruction and control
    Decode_Control #(.REG_BITS(REG_BITS)) control_unit(
        .instruction(instruction),
        .ALUOp(ALUOp),
        .PCSrc(PCSrc),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .StackWriteSrc(StackWriteSrc),
        .ALUSrc(ALUSrc),
        .StackUpdateMode(StackUpdateMode)
    );

    // sign extend for immediate
    Sign_Extend #(.REG_BITS(REG_BITS)) sign_extension(
        .in(instruction[REG_BITS-7:0]), 
        .out(immediate)
    );

    MUX2 #(.REG_BITS(REG_BITS)) alu_src_mux (
        .s(ALUSrc), 
        .d0(stack_read2), 
        .d1(immediate), 
        .out(operand2)
    );

    // ALU unit
    ALU #(.REG_BITS(REG_BITS)) alu (
        .ALUOp(ALUOp),
        .ALUSrc(ALUSrc),
        .opcode2(instruction[REG_BITS-4:REG_BITS-6]), 
        .operand1(stack_read1), 
        .operand2(operand2),
        .ALUResult(ALUResult)
    );

    // control branch
    Branch_Control #(.REG_BITS(REG_BITS)) branch_control (
        .PCSrc(PCSrc), 
        .opcode2(instruction[REG_BITS-4:REG_BITS-6]), 
        .operand(stack_read2), 
        .branch(branch)
    );
    
    // read or write data in Data Memory (Only instr group 3,4)
    Data_Memory #(.REG_BITS(REG_BITS)) dmem (
        .clk(clk),
        .MemRead(MemRead), 
        .MemWrite(MemWrite), 
        .addr(stack_read1), 
        .write_data(stack_read2), 
        .read_data(data_read)
    );
    
    // update Stack Pointer
    Stack_Pointer #(.REG_BITS(REG_BITS)) stack_pointer (
        .clk(clk),
        .StackUpdateMode(StackUpdateMode), 
        .SP_out(SP)
    );

    // decide whether write data on stack, and select what to write
    // StackWriteSrc 00: no write, 01: ALUresult, 10: dmem_read, 11: PC
    MUX4 #(.REG_BITS(REG_BITS)) stack_write_data_mux (
        .s0(StackWriteSrc[1]),
        .s1(StackWriteSrc[0]),
        .d0({REG_BITS{1'b0}}),
        .d1(ALUResult),
        .d2(data_read),
        .d3(PC),
        .out(stack_write_data)
    );

endmodule