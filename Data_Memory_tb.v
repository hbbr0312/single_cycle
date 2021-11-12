// Testbench for Data_Memory
`timescale 1ns/1ns

// -[x] check testbench
module testbench;
    // 32 bit
    reg MemRead, MemWrite;
    reg [31:0] addr;
    reg [31:0] write_data;
    
    wire [31:0] read_data;

    // read or write data in Data Memory (Only instr group 3,4)
    Data_Memory dmem (
        .MemRead(MemRead), 
        .MemWrite(MemWrite), 
        .addr(addr), 
        .write_data(write_data), 
        .read_data(read_data)
    );

    initial begin
        MemRead=0; MemWrite=0; addr=32'b0; write_data=32'b11; #50;
        MemRead=0; MemWrite=1; addr=32'b0; write_data=32'b11; #50; // write "11" at addr 0
        MemRead=1; MemWrite=0; addr=32'b0; write_data=32'b00; #50; // read at addr 0
        MemRead=0; MemWrite=1; addr=32'b1; write_data=32'b101; #50; // write "101" at addr 1
        MemRead=1; MemWrite=0; addr=32'b1; write_data=32'b000; #50; // read at addr 1
    end

endmodule