// Testbench for Stack_Pointer
`timescale 1ns/1ns

module testbench;
    parameter REG_BITS = 32;

    reg clk;
    reg [1:0] StackUpdateMode; //00: sp, 01: sp+1, 10: sp-2, 11: sp-1
    wire [REG_BITS-1:0] SP_out;

    Stack_Pointer #(.REG_BITS(REG_BITS)) stack_pointer (clk, StackUpdateMode, SP_out);

    initial begin
        clk = 0;
        
        stack_pointer.SP = 3'b100;
        StackUpdateMode = 2'b00;  #50; // sp = 4
        StackUpdateMode = 2'b10;  #50; // sp = 2
        StackUpdateMode = 2'b01;  #50; // sp = 3
        StackUpdateMode = 2'b11;  #50; // sp = 2
        StackUpdateMode = 2'b01;  #50; // sp = 3
        StackUpdateMode = 2'b01;  #50; // sp = 4
        StackUpdateMode = 2'b01;  #50; // sp = 5
    end

    always begin
        #25 clk = 1;
        #25 clk = 0;
    end
endmodule