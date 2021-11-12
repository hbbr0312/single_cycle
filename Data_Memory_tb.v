// Testbench for Data_Memory
`timescale 1ns/1ns


module testbench;
    parameter REG_BITS = 32;

    reg clk;
    reg MemRead, MemWrite;
    reg [REG_BITS-1:0] addr;
    reg [REG_BITS-1:0] write_data;
    
    wire [REG_BITS-1:0] read_data;

    // read or write data in Data Memory (Only instr group 3,4)
    Data_Memory #(.REG_BITS(REG_BITS)) dmem (
        .clk(clk),
        .MemRead(MemRead), 
        .MemWrite(MemWrite), 
        .addr(addr), 
        .write_data(write_data), 
        .read_data(read_data)
    );

    initial begin
        clk = 0;
        MemRead=0; MemWrite=0; addr=1'b0; write_data=2'b11; #50; // not written
        MemRead=0; MemWrite=1; addr=1'b0; write_data=2'b11; #50; // write "11" at addr 0
        MemRead=1; MemWrite=0; addr=1'b0; write_data=2'b00; #50; // read at addr 0
        MemRead=0; MemWrite=1; addr=1'b1; write_data=3'b101; #50; // write "101" at addr 1
        MemRead=1; MemWrite=0; addr=1'b1; write_data=3'b000; #50; // read at addr 1
    end

    always begin
        #25 clk = 1;
        #25 clk = 0;
    end

endmodule