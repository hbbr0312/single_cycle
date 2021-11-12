// 4x1 Multiplexor
module MUX4(s0, s1, d0, d1, d2, d3, out);
    parameter REG_BITS = 32;

    input s0, s1;
    input [REG_BITS-1:0] d0, d1, d2, d3;
    output [REG_BITS-1:0] out;

    assign out = s0? ( s1 ? d3 : d2 ) : ( s1 ? d1 : d0 );
    
endmodule
