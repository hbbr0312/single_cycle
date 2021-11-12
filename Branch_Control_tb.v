// Testbench for Branch_Control
`timescale 1ns/1ns

module testbench;
    parameter REG_BITS = 32;

    reg clk;
    reg [1:0] PCSrc; // 00: PC_temp, 01: branch, 10: pop_pc
    reg [2:0] opcode2;
    reg [REG_BITS-1:0] operand;

    wire branch;

    Branch_Control #(.REG_BITS(REG_BITS)) branch_control (
        .PCSrc(PCSrc), 
        .opcode2(opcode2), 
        .operand(operand), 
        .branch(branch)
    );

    initial begin
        clk = 0;
        
        PCSrc = 2'b00; opcode2 = 3'b000; operand = 1'b1; #50;  // branch = 0
        PCSrc = 2'b01; opcode2 = 3'b000; operand = 1'b0; #50;  // branch = 1 (branch_zero)
        PCSrc = 2'b01; opcode2 = 3'b000; operand = 1'b1; #50;  // branch = 0 (branch_zero)
        PCSrc = 2'b01; opcode2 = 3'b001; operand = 1'b1; #50;  // branch = 1 (branch_nzero)
        PCSrc = 2'b01; opcode2 = 3'b001; operand = 1'b0; #50;  // branch = 0 (branch_nzero)
        PCSrc = 2'b01; opcode2 = 3'b001; operand = 3'b101; #50;// branch = 1 (branch_nzero)
        PCSrc = 2'b10; opcode2 = 3'b000; operand = 1'b0; #50;  // branch = 1
        PCSrc = 2'b10; opcode2 = 3'b000; operand = 1'b1; #50;  // branch = 1

    end

    always begin
        #25 clk = 1;
        #25 clk = 0;
    end
endmodule