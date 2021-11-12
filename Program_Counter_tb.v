// Testbench for Controller for Program Counter
`timescale 1ns/1ns

module testbench;
    parameter REG_BITS = 32;

    reg clk, branch;
    reg [REG_BITS-1:0] target_addr;
    wire [REG_BITS-1:0] PC_in, PC_origin, PC_out;

    Program_Counter #(.REG_BITS(REG_BITS)) pc_register (clk, PC_in, PC_origin);
    PC_Adder #(.REG_BITS(REG_BITS)) pc_adder (PC_origin, PC_out);
    MUX2 #(.REG_BITS(REG_BITS)) pc_mux (
        .s(branch), 
        .d0(PC_out), 
        .d1(target_addr), 
        .out(PC_in)
    );

    initial begin
        clk = 0;
        pc_register.PC = {REG_BITS{1'b0}};
        #25;
        branch = 0; #50;
        branch = 1; target_addr = {REG_BITS{1'b1}}; #50;

    end

    always begin
        #25 clk = 1;
        #25 clk = 0;
    end
endmodule