/* 
 * Challenge #4 :
 * Implement the ALU in Verilog with only one 32-bit adder
 */

module ALU(ALUOp, ALUSrc, opcode2, operand1, operand2, ALUResult);
    parameter REG_BITS = 32;

    input ALUOp; // 0: Arithmetic, 1: Comparator
    input ALUSrc; // 0: stack, 1: immediate
    input [2:0] opcode2;
    input [REG_BITS-1:0] operand1, operand2;
    output [REG_BITS-1:0] ALUResult;

    wire [REG_BITS-1:0] AResult, CResult;

    Arithmetic #(.REG_BITS(REG_BITS)) AUnit(ALUSrc, opcode2, operand1, operand2, AResult);
    Comparator #(.REG_BITS(REG_BITS)) CUnit(opcode2, operand1, operand2, CResult);
    // ALUResult Multiplexor
    MUX2 #(.REG_BITS(REG_BITS)) alu_result_mux (
        .s(ALUOp), 
        .d0(AResult), 
        .d1(CResult), 
        .out(ALUResult)
    );

endmodule

// Group 1, 2:
//   add, sub, neg, mult, and, or, xor, not
module Arithmetic(ALUSrc, opcode2, op1, op2, AResult);
    parameter REG_BITS = 32;
    
    input ALUSrc;
    input [2:0] opcode2;
    input [REG_BITS-1:0] op1, op2;
    output reg [REG_BITS-1:0] AResult;

    always @(opcode2 or op1 or op2) begin
        case(opcode2)
            // add
            3'b000: AResult = op1 + op2;

            // sub
            3'b001: begin
                AResult = op1 + (~op2 + 1); // ~op2 + 1 = -op
            end

            // neg
            3'b010: begin
                AResult = ALUSrc ? ~op2 : ~op1;
            end

            // mult
            3'b011: begin
                AResult = op1 * op2;
            end

            // and
            3'b100: begin
                AResult = op1 & op2;
            end

            // or
            3'b101: begin
                AResult = op1 | op2;
            end

            // xor
            3'b110: begin
                AResult = op1 ^ op2;
            end

            // not
            3'b111: begin
                AResult = ALUSrc ? !op2 : !op1;
            end
        endcase
    end

endmodule

// Group 5:
//   eq, gt, leq
module Comparator(opcode2, op1, op2, CResult);
    parameter REG_BITS = 32;

    input [2:0] opcode2;
    input [REG_BITS-1:0] op1, op2;
    output reg [REG_BITS-1:0] CResult;

    reg [REG_BITS-1:0] temp;
    wire [REG_BITS-1:0] zero;


    always @(opcode2 or op1 or op2) begin
        // eq
        if (opcode2 == 3'b000) begin
            if (op1 == op2) CResult = 1'b1;
            else CResult = 1'b0;
        end

        // gt
        else if (opcode2 == 3'b001) begin
            // determine with sign bit of (op2 - op1)
            // if only op1 > op2, return 1
            // op2 - op1 < 0 ==> just return sign bit of (op2 - op1)
            temp = op2 + (~op1 + 1);
            CResult = temp[REG_BITS-1];
        end

        // leq
        else if (opcode2 == 3'b010) begin
            // determine with sign bit of (op2 - op1)
            // if only op1 <= op2, return
            // op2 - op1 >=0 ==> then sign bit must be zero => return 1
            temp = op2 + (~op1 + 1);
            CResult = !temp[REG_BITS-1];
        end
    end

endmodule
