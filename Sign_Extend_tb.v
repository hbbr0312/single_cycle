// Testbench for Sign_Extend
`timescale 1ns/1ns

module testbench;
    parameter REG_BITS = 32;

    reg clk;
    reg [REG_BITS-7:0] in;
    wire [REG_BITS-1:0] out;

    Sign_Extend #(.REG_BITS(REG_BITS)) sign_extend (in, out);

    initial begin
        clk = 0;
        
        in = 26'b00000000000000000000000001; #50;
        in = 26'b11111111111111111111111111; #50;
        in = 26'b01111111111111111111111111; #50;

    end

    always begin
        #25 clk = 1;
        #25 clk = 0;
    end
endmodule