/* 
 * Challenge #2 :
 * Design a stack with 16, 32-bit registers 
 * and implement it with Verilog
 * and make your code parametric
 */ 

// Stack_Memory
// Stack register bit: REG_BITS (32 or 16)
// width: REG_BITS
// height: 64
module Stack_Memory(clk, StackWriteSrc, SP, write_data, read1, read2);
    parameter REG_BITS = 32;
    
    input clk;
    input [1:0] StackWriteSrc;
    input [REG_BITS-1:0] SP; // Stack Poiter
    input [REG_BITS-1:0] write_data;
    output reg [REG_BITS-1:0] read1, read2;

    reg [REG_BITS-1:0] stack [63: 0];

    always @(posedge clk) begin
        read1 = stack[SP];
        read2 = stack[SP-1];
    end

    always @(write_data) begin
        if (StackWriteSrc)
            stack[SP] = write_data;
    end

endmodule
    