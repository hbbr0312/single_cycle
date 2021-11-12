module Program_Counter(clk, PC_in, PC_out);
    parameter REG_BITS = 32;

    input clk;
    input [REG_BITS-1:0] PC_in;
    output [REG_BITS-1:0] PC_out;

    reg [REG_BITS-1:0] PC;

    assign PC_out = PC;

    always @(posedge clk) begin
        PC = PC_in;
    end

endmodule


module PC_Adder(PC_in, PC_out);
    parameter REG_BITS = 32;

    input [REG_BITS-1:0] PC_in;
    output [REG_BITS-1:0] PC_out;

    MUX2 adder_select(
        .s(REG_BITS == 32), 
        .d0(PC_in+2), 
        .d1(PC_in+4), 
        .out(PC_out)
    );
endmodule