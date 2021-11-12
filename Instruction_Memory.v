// Instruction_Memory
// width: 8 (1 byte)
// height: 256  -> modify later
// byte address
module Instruction_Memory(clk, PC, instruction);
    parameter REG_BITS = 32;

    input clk;
    input [REG_BITS-1:0] PC;
    output reg [REG_BITS-1:0] instruction;

    reg [7:0] imem [255:0]; // byte address

    always @(posedge clk) begin
        if (REG_BITS == 32) instruction = {imem[PC], imem[PC+1], imem[PC+2], imem[PC+3]};
        else instruction = {imem[PC], imem[PC+1]};
    end

endmodule