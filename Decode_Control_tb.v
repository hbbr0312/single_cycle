// Testbench for Decode_Control
`timescale 1ns/1ns

// -[x] check testbench
module testbench;
    reg [31:0] instruction;

    wire [1:0] ALUOp; // 00: no op, 01: group1,2, 10: comparator
    wire [1:0] PCSrc; // 00: PC_temp, 01: branch, 10: pop_pc
    wire MemRead;
    wire MemWrite;
    wire [1:0] StackWriteSrc; // 00: no write, 01: ALUresult, 10: dmem_read, 11: PC_temp
    wire ALUSrc; // 0: stack, 1: immediate
    wire [1:0] StackUpdateMode; //00: sp, 01: sp+1, 10: sp-2, 11: sp-1

    Decode_Control control_unit (
        .instruction(instruction), 
        .ALUOp(ALUOp),
        .PCSrc(PCSrc),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .StackWriteSrc(StackWriteSrc),
        .ALUSrc(ALUSrc),
        .StackUpdateMode(StackUpdateMode)
    );

    initial begin
        instruction = {3'b000, 3'b000, 26'b0}; #50; // group1 - add operation
        instruction = {3'b000, 3'b010, 26'b0}; #50; // group1 - neg operation (unary)
        instruction = {3'b001, 3'b110, 26'b0}; #50; // group2 - xori operation
        instruction = {3'b001, 3'b111, 26'b0}; #50; // group2 - noti operation (unary)
        instruction = {3'b010, 3'b111, 26'b0}; #50; // group3 - push, ignore opcode2
        instruction = {3'b011, 3'b111, 26'b0}; #50; // group4 - pop,  ignore opcode2
        instruction = {3'b100, 3'b000, 26'b0}; #50; // group5 - eq
        instruction = {3'b101, 3'b001, 26'b0}; #50; // group6 - branch_nzero
        instruction = {3'b110, 3'b111, 26'b0}; #50; // group7 - push_pc, ignore opcode2
        instruction = {3'b111, 3'b111, 26'b0}; #50; // group8 - pop_pc, ignore opcode2
    end
endmodule