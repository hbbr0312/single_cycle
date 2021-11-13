// Testbench for Single Cycle Stack Machine
`timescale 1ns/1ns

module testbench;
    parameter REG_BITS = 32;  // # of bits for register

    reg clk;
    reg [REG_BITS-1:0] instruction;
    single_cycle #(.REG_BITS(REG_BITS)) single_cycle_stack_machine (clk);

    initial begin
        clk = 0;
        if (REG_BITS == 16) begin
            // push b100
            // subi 10
            // pop
            // xor
            // push_pc

            // instruction
            single_cycle_stack_machine.fetch_instr.imem[0] = 8'b01000000; 
            single_cycle_stack_machine.fetch_instr.imem[1] = 8'b00000000; // push
            single_cycle_stack_machine.fetch_instr.imem[2] = 8'b00100100;
            single_cycle_stack_machine.fetch_instr.imem[3] = 8'b00000010; // subi 10
            single_cycle_stack_machine.fetch_instr.imem[4] = 8'b01100000;
            single_cycle_stack_machine.fetch_instr.imem[5] = 8'b00000000; // pop
            single_cycle_stack_machine.fetch_instr.imem[6] = 8'b00011000;
            single_cycle_stack_machine.fetch_instr.imem[7] = 8'b00000000; // xor
            single_cycle_stack_machine.fetch_instr.imem[8] = 8'b11000000;
            single_cycle_stack_machine.fetch_instr.imem[9] = 8'b00000000; // push_pc

            // data memory
            single_cycle_stack_machine.dmem.dmem[0] = 3'b000;
            single_cycle_stack_machine.dmem.dmem[1] = 3'b000;
            single_cycle_stack_machine.dmem.dmem[2] = 3'b000;
            single_cycle_stack_machine.dmem.dmem[3] = 3'b100;


            // stack memory
            single_cycle_stack_machine.stack.stack[0] = 4'b1010;
            single_cycle_stack_machine.stack.stack[1] = 4'b1100;
            single_cycle_stack_machine.stack.stack[2] = 3'b101;
            single_cycle_stack_machine.stack.stack[3] = 3'b011;

            //pc sp
            single_cycle_stack_machine.pc_register.PC = 0;
            single_cycle_stack_machine.stack_pointer.SP = 3'b011;
            single_cycle_stack_machine.branch_control.branch = 1'b0;
        end

        if (REG_BITS == 32) begin
            // negi 111...00 => 000...11 (3)
            // noti 0 => 1
            // sub => 1 - 3 = -2 (11..110)
            // neg => 11111...101 

            // initialize registers
            single_cycle_stack_machine.pc_register.PC = 0;
            single_cycle_stack_machine.stack_pointer.SP = 0;
            single_cycle_stack_machine.branch_control.branch = 0;

            /* instruction */
            // negi 111..100
            instruction = 32'b00101011111111111111111111111100;
            single_cycle_stack_machine.fetch_instr.imem[0] = instruction[31:24]; 
            single_cycle_stack_machine.fetch_instr.imem[1] = instruction[23:16];
            single_cycle_stack_machine.fetch_instr.imem[2] = instruction[15:8];
            single_cycle_stack_machine.fetch_instr.imem[3] = instruction[7:0];
            
            // noti 0
            instruction = 32'b00111100000000000000000000000000;
            single_cycle_stack_machine.fetch_instr.imem[4] = instruction[31:24]; 
            single_cycle_stack_machine.fetch_instr.imem[5] = instruction[23:16];
            single_cycle_stack_machine.fetch_instr.imem[6] = instruction[15:8];
            single_cycle_stack_machine.fetch_instr.imem[7] = instruction[7:0];

            // sub
            instruction = 32'b00000100000000000000000000000000;
            single_cycle_stack_machine.fetch_instr.imem[8] = instruction[31:24]; 
            single_cycle_stack_machine.fetch_instr.imem[9] = instruction[23:16];
            single_cycle_stack_machine.fetch_instr.imem[10] = instruction[15:8];
            single_cycle_stack_machine.fetch_instr.imem[11] = instruction[7:0];

            // neg
            instruction = 32'b00001000000000000000000000000000;
            single_cycle_stack_machine.fetch_instr.imem[12] = instruction[31:24]; 
            single_cycle_stack_machine.fetch_instr.imem[13] = instruction[23:16];
            single_cycle_stack_machine.fetch_instr.imem[14] = instruction[15:8];
            single_cycle_stack_machine.fetch_instr.imem[15] = instruction[7:0];
        end
    end

    always begin
        #25 clk = 1;
        #25 clk = 0;
    end
endmodule