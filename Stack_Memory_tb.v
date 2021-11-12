// Testbench for Stack_Memory
`timescale 1ns/1ns

// -[] check testbench
module testbench;
    reg clk;
    reg [1:0] StackWriteSrc; // 00: no write, 01: ALUresult, 10: dmem_read, 11: PC_temp
    reg [31:0] SP; // Stack Poiter
    reg [31:0] write_data = 0;

    wire [31:0] read1, read2;

    Stack_Memory Unit12 (
        .clk(clk), 
        .StackWriteSrc(StackWriteSrc), 
        .SP(SP), 
        .write_data(write_data), 
        .read1(read1), 
        .read2(read2)
    );

    initial begin
        clk = 0;
        
        #25; StackWriteSrc = 0; SP = 1; write_data = 0;
        #5; StackWriteSrc = 2'b11; SP = 0;
        #20; write_data = 31'b111;
        #25; StackWriteSrc = 0; SP = 1; write_data = 0;






    end

    always begin
        #25 clk = 1;
        #25 clk = 0;
    end
endmodule