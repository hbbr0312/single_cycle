
module Stack_Pointer(clk, StackUpdateMode, SP_out);
    parameter REG_BITS = 32;
    
    input clk;
    input [1:0] StackUpdateMode;
    output [REG_BITS-1:0] SP_out;
    
    reg [REG_BITS-1:0] SP;

    assign SP_out = SP;

    always @(posedge clk) begin
        case(StackUpdateMode)
            2'b10: SP = SP-2;
            2'b11: SP = SP-1;
            2'b00: SP = SP;
            2'b01: SP = SP+1;
            default: SP = SP; // not reach
        endcase
    end

endmodule