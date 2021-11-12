// Testbench for Instruction_Memory
`timescale 1ns/1ns

module testbench;
    parameter REG_BITS = 32;

    reg clk;
    reg [REG_BITS-1:0] PC;
    wire [REG_BITS-1:0] instruction;

    Instruction_Memory #(.REG_BITS(REG_BITS)) fetch_instr (
        clk, PC, instruction
    );

    initial begin
        clk = 0;

        if (REG_BITS == 16) begin
            // PC=0 -> "1111000011110000"
            fetch_instr.imem[0] = 8'b11110000; fetch_instr.imem[1] = 8'b11110000;
            // PC=2 -> "0000111100001111"
            fetch_instr.imem[2] = 8'b00001111; fetch_instr.imem[3] = 8'b00001111; 

            #25;
        
            PC = 0; #50; //  "1111000011110000"
            PC = 2; #50; //  "0000111100001111"          
        end
        if (REG_BITS == 32) begin
            // PC=0 -> "11110000111100001111000011110000"
            fetch_instr.imem[0] = 8'b11110000; fetch_instr.imem[1] = 8'b11110000; fetch_instr.imem[2] = 8'b11110000; fetch_instr.imem[3] = 8'b11110000; 
            // PC=4 -> "00001111000011110000111100001111"     
            fetch_instr.imem[4] = 8'b00001111; fetch_instr.imem[5] = 8'b00001111; fetch_instr.imem[6] = 8'b00001111; fetch_instr.imem[7] = 8'b00001111;       
            
            #25;
        
            PC = 0; #50; //  "11110000111100001111000011110000"
            PC = 4; #50; //  "00001111000011110000111100001111"       
        end
    end

    always begin
        #25 clk = 1;
        #25 clk = 0;
    end
endmodule