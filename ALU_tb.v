// Testbench for ALU
`timescale 1ns/1ns

module testbench;
    parameter REG_BITS = 32;

    reg clk;

    reg ALUOp; // 0: Arithmetic, 1: Comparator
    reg ALUSrc; // 0: stack, 1: immediate
    reg [2:0] opcode2;
    reg [REG_BITS-1:0] operand1, operand2;

    wire [REG_BITS-1:0] ALUResult;

    ALU #(.REG_BITS(REG_BITS)) alu (
        .ALUSrc(ALUSrc),
        .ALUOp(ALUOp),
        .opcode2(opcode2), 
        .operand1(operand1), 
        .operand2(operand2),
        .ALUResult(ALUResult)
    );

    initial begin
        clk = 1;
        // Arithmetic
        // add, sub, neg, mult, and, or, xor, not
        ALUOp = 0; ALUSrc = 0; opcode2 = 3'b000; operand1 = 2'b10; operand2 = 2'b01; #25; // add 2, 1 =>  3(b11)
        ALUOp = 0; ALUSrc = 0; opcode2 = 3'b001; operand1 = 2'b01; operand2 = 2'b10; #25; // sub 1, 2 => -1(1111...111)
        ALUOp = 0; ALUSrc = 0; opcode2 = 3'b010; operand1 = 19'b1111111111111111111; #25; // neg
        ALUOp = 0; ALUSrc = 0; opcode2 = 3'b011; operand1 = 2'b10; operand2 = 2'b10; #25; // mult 2,2 =>  4(b100)
        ALUOp = 0; ALUSrc = 0; opcode2 = 3'b100; operand1 = 2'b10; operand2 = 2'b01; #25; // and 2, 1 =>  0
        ALUOp = 0; ALUSrc = 0; opcode2 = 3'b101; operand1 = 2'b10; operand2 = 2'b01; #25; // or  2, 1 =>  3(b11)
        ALUOp = 0; ALUSrc = 0; opcode2 = 3'b110; operand1 = 2'b10; operand2 = 2'b11; #25; // xor 2, 3 =>  1(b01)
        ALUOp = 0; ALUSrc = 0; opcode2 = 3'b111; operand1 = 19'b1111111111111111111; #25; // not      => 0

        // Comparator
        // eq, gt, leq
        ALUOp = 1; opcode2 = 3'b000; operand1 = 2'b10;            operand2 = 2'b01; #25; // eq 2, 1 => 0
        ALUOp = 1; opcode2 = 3'b001; operand1 = {REG_BITS{1'b1}}; operand2 = 2'b01; #25; // gt -1, 1 => 0
        ALUOp = 1; opcode2 = 3'b010; operand1 = 2'b10;            operand2 = 2'b11; #25; // leq 2, 3 => 1

    end

    always begin
        #25 clk = 0;
        #25 clk = 1;
    end
endmodule