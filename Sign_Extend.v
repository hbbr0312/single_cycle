// Sign Extend for immediate
module Sign_Extend(in, out);
    parameter REG_BITS = 32;

    input [REG_BITS-7:0] in;
    output [REG_BITS-1:0] out;

    assign out = {{6{in[REG_BITS-7]}}, in[REG_BITS-7:0]};

endmodule
