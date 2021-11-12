
// 2x1 Multiplexor
module MUX2(s, d0, d1, out);
    parameter REG_BITS = 32;

    input s;
    input [REG_BITS-1:0] d0, d1;
    output [REG_BITS-1:0] out;

    assign out = s ? d1 : d0;
endmodule