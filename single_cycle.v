// author: Guseul Heo
// start date: November 9, 2021
// end date: November 11, 2021

/* 
 * Challenge #3 :
 * Design the single-cycle stack machine
 */

module single_cycle(clk);
    parameter REG_BITS = 32; // 16 or 32

    input clk;
    wire [REG_BITS-1:0] instruction;
    
    wire [REG_BITS-1:0] PC_in, PC_out, SP;
    wire [REG_BITS-1:0] stack_read1, stack_read2, operand2;
    wire [REG_BITS-1:0] data_read, ALUResult;

    wire [REG_BITS-1:0] stack_write_data;
    wire [REG_BITS-1:0] immediate; // sign extended immediate

    wire [1:0] ALUOp;
    wire MemRead, MemWrite;
    wire [1:0] PCSrc; // 00: PC_temp, 01: branch, 10: pop_pc
    wire [1:0] StackWriteSrc; // 00: no write, 01: ALUresult, 10: dmem_read, 11: PC_temp
    wire ALUSrc; // 0: stack, 1: immediate
    wire [1:0] StackUpdateMode;
    wire branch;

    // fetch instrcution
    Instruction_Memory Unit1 (
        .clk(clk), 
        .PC(PC_out), 
        .instruction(instruction)
    );

    // increment Program Counter
    Program_Counter Unit2 (
        .clk(clk),
        .branch(branch),
        .PC_in(PC_in), 
        .PC_out(PC_out)
    );

    // read top and next top data of stack
    Stack_Memory Unit3(
        .clk(clk), 
        .StackWriteSrc(StackWriteSrc), 
        .SP(SP), 
        .write_data(stack_write_data), 
        .read1(stack_read1), 
        .read2(stack_read2)
    );
    
    // decode instruction and control
    Decode_Control Unit4(
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
    Sign_Extend Unit5(
        .in(instruction[REG_BITS-7:0]), 
        .out(immediate)
    );
    
    MUX2 Unit6 (
        .s(ALUSrc), 
        .in1(stack_read2), 
        .in2(immediate), 
        .out(operand2)
    );

    // ALU unit
    ALU Unit7 (
        .ALUop(ALUOp),
        .opcode2(instruction[REG_BITS-4:REG_BITS-6]), 
        .operand1(stack_read1), 
        .operand2(operand2),
        .ALUResult(ALUResult)
    );

    // control branch
    Branch_Control Unit8 (
        .PCSrc(PCSrc), 
        .opcode2(instruction[REG_BITS-4:REG_BITS-6]), 
        .operand(stack_read1), 
        .branch(branch)
    );
    
    // read or write data in Data Memory (Only instr group 3,4)
    Data_Memory Unit9 (
        .MemRead(MemRead), 
        .MemWrite(MemWrite), 
        .addr(stack_read1), 
        .write_data(stack_read2), 
        .read_data(data_read)
    );
    
    // update Stack Pointer
    Stack_Pointer Unit10 (
        .StackUpdateMode(StackUpdateMode), 
        .SP_out(SP)
    );

    // decide whether write data on stack, and select what to write
    Select_Write_Data Unit11 (
        .StackWriteSrc(StackWriteSrc), 
        .PC(PC_out), 
        .data_read(data_read), 
        .ALUResult(ALUResult), 
        .stack_write_data(stack_write_data)
    );

endmodule


module Program_Counter(clk, branch, PC_in, PC_out);
    parameter REG_BITS = 32;

    input clk, branch;
    input [REG_BITS-1:0] PC_in;
    output [REG_BITS-1:0] PC_out;

    reg [REG_BITS-1:0] PC;

    assign PC_out = PC;

    always @(posedge clk) begin
        if (REG_BITS == 16) PC = PC + 2;
        else PC = PC + 4;
    end

    always @(branch) begin
        if (branch) PC = PC_in;
    end

endmodule


module Branch_Control(PCSrc, opcode2, operand, branch);
    parameter REG_BITS = 32;

    input [1:0] PCSrc;
    input [2:0] opcode2;
    input [REG_BITS-1:0] operand;

    output branch;

    always @(PCSrc) begin
        case(opcode2)
            3'b000: begin // branch_zero
                if (operand == 0) branch = 1'b1;
                else branch = 1'b0;
            end
            3'b001: begin // branch_nzero
                if (operand == 0) branch = 1'b0;
                else branch = 1'b1;
            end
            default: branch = 1'b0;
        endcase
    end

endmodule

// update Stack Pointer
module Stack_Pointer(StackUpdateMode, SP_out);
    parameter REG_BITS = 32;
    
    input [1:0] StackUpdateMode;
    output [REG_BITS-1:0] SP_out;
    reg [REG_BITS-1:0] SP;

    assign SP_out = SP;

    always @(StackUpdateMode) begin
        case(StackUpdateMode)
            2'b10: SP = SP-2;
            2'b11: SP = SP-1;
            2'b00: SP = SP;
            2'b01: SP = SP+1;
            default: SP = SP; // not reach
        endcase
    end

endmodule

// decide whether write data on stack, and select what to write
module Select_Write_Data(StackWriteSrc, PC, data_read, ALUResult, stack_write_data);
    parameter REG_BITS = 32;

    input [1:0] StackWriteSrc; // 00: no write, 01: ALUresult, 10: dmem_read, 11: PC
    input [REG_BITS-1:0] PC, data_read, ALUResult;
    output reg [REG_BITS-1:0] stack_write_data;

    always @(StackWriteSrc or ALUResult or data_read or PC) begin
        case(StackWriteSrc)
            2'b01: stack_write_data = ALUResult;
            2'b10: stack_write_data = data_read;
            2'b11: stack_write_data = PC;
            default: stack_write_data = {REG_BITS{1'b0}};
        endcase
    end
endmodule


// Sign Extend for immediate
module Sign_Extend(in, out);
    parameter REG_BITS = 32;

    input [REG_BITS-7:0] in;
    output [REG_BITS-1:0] out;

    assign out = {{6{in[REG_BITS-7]}}, in[REG_BITS-7:0]};

endmodule


// 2x1 Multiplexor
module MUX2(s, in1, in2, out);
    parameter REG_BITS = 32;

    input s;
    input [REG_BITS-1:0] in1, in2;
    output [REG_BITS-1:0] out;

    assign out = s ? in2 : in1;
endmodule