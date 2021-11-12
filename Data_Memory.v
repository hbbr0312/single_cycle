// Data Memory
// width: REG_BITS (32 or 16)
// height: 64

// -[] write testbench
// -[] check testbench
module Data_Memory(MemRead, MemWrite, addr, write_data, read_data);
    parameter REG_BITS = 32;

    input MemRead, MemWrite;
    input [REG_BITS-1:0] addr;
    input [REG_BITS-1:0] write_data;
    output reg [REG_BITS-1:0] read_data;

    reg [REG_BITS-1:0] dmem [63:0];

    always @(MemRead or MemWrite) begin
        if (MemRead)
            read_data = dmem[addr];
        if (MemWrite)
            dmem[addr] = write_data;
    end

endmodule