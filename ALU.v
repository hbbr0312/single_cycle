/* 
 * Challenge #4 :
 * Implement the ALU in Verilog with only one 32-bit adder
 */

module ALU(ALUop, opcode2, operand1, operand2, ALUResult);
    parameter REG_BITS = 32;

    input [1:0] ALUop;
    input [2:0] opcode2;
    input [REG_BITS-1:0] operand1, operand2;
    output [REG_BITS-1:0] ALUResult;

    wire a_enable, c_enable;

    assign a_enable = ALUop == 2'b01;
    assign c_enable = ALUop == 2'b10;

    Arithmetic AUnit(a_enable, opcode2, operand1, operand2, ALUResult);
    Comparator CUnit(c_enable, opcode2, operand1, operand2, ALUResult);

endmodule

// Group 1, 2:
//   add, sub, neg, mult, and, or, xor, not
module Arithmetic(enable, opcode2, op1, op2, ALUResult);
    parameter REG_BITS = 32;

    input enable;
    input [2:0] opcode2;
    input [REG_BITS-1:0] op1, op2;
    output reg [REG_BITS-1:0] ALUResult;

    always @(op2) begin
        if (enable) begin
            case(opcode2)
                // add
                3'b000: begin
                    ALUResult = op1 + op2;
                end

                // sub
                3'b001: begin
                    ALUResult = op1 + (~op2 + 1); // ~op2 + 1 = -op
                end

                // neg
                3'b010: begin
                    ALUResult = ~op1;
                end

                // mult
                3'b011: begin
                    ALUResult = op1 * op2;
                end

                // and
                3'b100: begin
                    ALUResult = op1 & op2;
                end

                // or
                3'b101: begin
                    ALUResult = op1 | op2;
                end

                // xor
                3'b110: begin
                    ALUResult = op1 ^ op2;
                end

                // not
                3'b111: begin
                    ALUResult = !op1;
                end
            endcase
        end
    end

endmodule

// Group 5:
//   eq, gt, leq
module Comparator(enable, opcode2, op1, op2, ALUResult);
    parameter REG_BITS = 32;

    input enable;
    input [2:0] opcode2;
    input [REG_BITS-1:0] op1, op2;
    output reg [REG_BITS-1:0] ALUResult;

    reg [REG_BITS-1:0] temp;
    wire [REG_BITS-1:0] zero;

    assign zero = {REG_BITS{1'b0}};

    always @(op2) begin
        if (enable) begin
            // eq
            if (opcode2 == 3'b000) begin
                if (op1 == op2) ALUResult = zero & 1'b1; //1
                else ALUResult = zero;//0
            end

            // gt
            else if (opcode2 == 3'b001) begin
                // determine with sign bit of (op1-op2)
                // op1-op2 < 0 : sign bit = 1
                // else: sign bit = 0
                temp = op1 + (~op2 + 1);
                if (temp[REG_BITS-1]) ALUResult = zero & 1'b1;
                else ALUResult = zero;
            end

            // leq
            else if (opcode2 == 3'b010) begin
                // determine with sign bit of (op1-op2)
                // op1-op2 < 0 : sign bit = 1
                // else: sign bit = 0
                temp = op1 + (~op2 + 1);
                if (temp[REG_BITS-1]) ALUResult = zero;
                else ALUResult =zero & 1'b1;
            end
        end
    end

endmodule