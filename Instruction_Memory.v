// Instruction_Memory
// width: REG_BITS (32 or 16)
// height: 64

module Instruction_Memory(clk, PC, instruction);
    parameter REG_BITS = 32;

    input clk;
    input [REG_BITS-1:0] PC;
    output reg [REG_BITS-1:0] instruction;

    reg [REG_BITS-1:0] imem [63:0]; // modify height

    always @(posedge clk) begin
        instruction = imem[PC];
    end

endmodule