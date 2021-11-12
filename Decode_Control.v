/* 
 * Challenge #5 :
 * Implement the instruction decoder
 * and the controller in Verilog
 */

module Decode_Control(
    instruction, 
    ALUOp,
    PCSrc,
    MemRead,
    MemWrite,
    StackWriteSrc,
    ALUSrc,
    StackUpdateMode
    );

    parameter REG_BITS = 32;

    input [REG_BITS-1:0] instruction;

    reg [2:0] opcode1;
    reg [2:0] opcode2;

    output reg ALUOp; // 0: default, 1: comparator
    output reg [1:0] PCSrc; // 00: PC_temp, 01: branch, 10: pop_pc
    output reg MemRead;
    output reg MemWrite;
    output reg [1:0] StackWriteSrc; // 00: no write, 01: ALUresult, 10: dmem_read, 11: PC_temp
    output reg ALUSrc; // 0: stack, 1: immediate
    output reg [1:0] StackUpdateMode; //00: sp, 01: sp+1, 10: sp-2, 11: sp-1

    always @(instruction) begin
        opcode1 = instruction[REG_BITS-1:REG_BITS-3];
        opcode2 = instruction[REG_BITS-4:REG_BITS-6];

        case(opcode1)
            // Group 1: add, sub, neg, mult, and, or, xor, not
            3'b000: begin
                ALUOp = 1'b0;
                PCSrc = 2'b00;
                MemRead = 0;
                MemWrite = 0;
                StackWriteSrc = 2'b01;
                ALUSrc = 0;
                if (opcode2 == 3'b111 || opcode2 == 3'b010) StackUpdateMode = 2'b00;
                else StackUpdateMode = 2'b11;

            end
            // Group 2: addi, subi, negi, multi, andi, ori, xori, noti
            3'b001: begin
                ALUOp = 1'b0;
                PCSrc = 2'b00;
                MemRead = 0;
                MemWrite = 0;
                StackWriteSrc = 2'b01;
                ALUSrc = 1;
                if (opcode2 == 3'b111 || opcode2 == 3'b010) StackUpdateMode = 2'b01;
                else StackUpdateMode = 2'b00;

            end
            // Group 3: push
            3'b010: begin
                ALUOp = 1'b0;
                PCSrc = 2'b00;
                MemRead = 1;
                MemWrite = 0;
                StackWriteSrc = 2'b10;
                ALUSrc = 0;
                StackUpdateMode = 2'b00;
                
            end
            // Group 4: pop
            3'b011: begin
                ALUOp = 1'b0;
                PCSrc = 2'b00;
                MemRead = 0;
                MemWrite = 1;
                StackWriteSrc = 2'b00;
                ALUSrc = 0;
                StackUpdateMode = 2'b10;
                
            end
            // Group 5: eq, gt, leq
            3'b100: begin
                ALUOp = 1'b1;
                PCSrc = 2'b00;
                MemRead = 0;
                MemWrite = 0;
                StackWriteSrc = 2'b01;
                ALUSrc = 0;
                StackUpdateMode = 2'b11;

            end
            // Group 6: branch_zero, branch_nzero
            3'b101: begin
                ALUOp = 1'b0;
                PCSrc = 2'b01;
                MemRead = 0;
                MemWrite = 0;
                StackWriteSrc = 2'b00;
                ALUSrc = 0;
                StackUpdateMode = 2'b10;
                
            end
            // Group 7: push_pc
            3'b110: begin
                ALUOp = 1'b0;
                PCSrc = 2'b00;
                MemRead = 0;
                MemWrite = 0;
                StackWriteSrc = 2'b11;
                ALUSrc = 0;
                StackUpdateMode = 2'b01;
                
            end
            // Group 8: pop_pc
            3'b111: begin
                ALUOp = 1'b0;
                PCSrc = 2'b10;
                MemRead = 0;
                MemWrite = 0;
                StackWriteSrc = 2'b00;
                ALUSrc = 0;
                StackUpdateMode = 2'b11;
                
            end
        endcase
    end
endmodule