// Testbench for Stack_Memory
`timescale 1ns/1ns

module testbench;
    parameter REG_BITS = 32;

    reg clk;
    reg [1:0] StackWriteSrc; // 00: no write, 01: ALUresult, 10: dmem_read, 11: PC_temp
    reg [31:0] SP;
    reg [31:0] write_data = 0;

    wire [31:0] read1, read2;

    Stack_Memory #(.REG_BITS(REG_BITS)) stack (
        .clk(clk), 
        .StackWrite(!(!StackWriteSrc)), 
        .SP(SP), 
        .write_data(write_data), 
        .read1(read1), 
        .read2(read2)
    );

    initial begin
        clk = 1;
        StackWriteSrc = 2'b00; SP = 0;  write_data = 0;      #50; // read sp: 0(x), -(x)
        StackWriteSrc = 2'b10; SP = 1;  write_data = 3'b111; #50; // read sp: 1(x), 0(x)
        StackWriteSrc = 2'b01; SP = 2;  write_data = 3'b100; #50; // read sp: 2(x), 1(111)
        StackWriteSrc = 2'b11; SP = 3;  write_data = 3'b011; #50; // read sp: 3(x), 2(100)
        StackWriteSrc = 2'b00; SP = 4;  write_data = 3'b000; #50; // read sp: 4(x), 3(011)
        StackWriteSrc = 2'b11; SP = 5;  write_data = 3'b111; #50; // read sp: 5(x), 4(x)
        StackWriteSrc = 2'b11; SP = 6;  write_data = 3'b101; #50; // read sp: 6(x), 5(111)
    end

    always begin
        #25 clk = 0;
        #25 clk = 1;
    end
endmodule