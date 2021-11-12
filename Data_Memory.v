// Data Memory
// width: REG_BITS (32 or 16)
// height: 64 -> modify later
// word address
module Data_Memory(clk, MemRead, MemWrite, addr, write_data, read_data);
    parameter REG_BITS = 32;

    input clk;
    input MemRead, MemWrite;
    input [REG_BITS-1:0] addr, write_data;
    output reg [REG_BITS-1:0] read_data;

    reg [REG_BITS-1:0] dmem [63:0];

    always @(negedge clk) begin
        if (MemRead)
            read_data = dmem[addr];
        if (MemWrite)
            dmem[addr] = write_data;
    end

endmodule