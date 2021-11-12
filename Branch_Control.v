module Branch_Control(PCSrc, opcode2, operand, branch);
    parameter REG_BITS = 32;

    input [1:0] PCSrc;
    input [2:0] opcode2;
    input [REG_BITS-1:0] operand;

    output reg branch;

    always @(PCSrc or opcode2 or operand) begin
        if (PCSrc == 2'b10) branch = 1'b1;
        else if (PCSrc == 2'b00) branch = 1'b0;
        else begin    
            case(opcode2)
                3'b000: begin // branch_zero
                    if (operand == 0) branch = 1'b1;
                    else branch = 1'b0;
                end
                3'b001: begin // branch_nzero
                    if (operand == 0) branch = 1'b0;
                    else branch = 1'b1;
                end
                default: branch = 1'b0;
            endcase
        end
    end

endmodule