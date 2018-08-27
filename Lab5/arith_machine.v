// arith_machine: execute a series of arithmetic instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clock  (input)  - the clock signal
// reset  (input)  - set to 1 to set all registers to zero, set to 0 for normal execution.

module arith_machine(except, clock, reset);
    output      except;
    input       clock, reset;

    wire [31:0] inst;  
    wire [31:0] PC,nextPC;  
    wire [31:0] B,imm32;
    wire [2:0] alu_op;
    wire [15:0] bus;
    wire [4:0] rdNum;
    wire writeenable,rd_src,alu_src2;
    wire [5:0]opcode;
    wire [5:0]funct;
    wire [31:0] rsData,out,rdData,rtData;
    wire zero,negative,overflow;
    
    assign opcode = inst[31:26];
    assign funct = inst[5:0];
    alu32 al(nextPC,,,,PC,32'h4,`ALU_ADD);
    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(32) PC_reg(PC, nextPC, clock, 1'b1, reset);
    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory im(inst, PC[31:2]);
    // assign except = 0;
    // DO NOT comment out or rename this module
    // or the test bench will break


    mux2v #(5) mx1(rdNum,inst[15:11],inst[20:16],rd_src);
    
    regfile rf (rsData,rtData,inst[25:21], inst[20:16], rdNum, rdData,writeenable, clock, reset);
    alu32 al1(rdData,zero, negative, overflow, rsData, B, alu_op);
    mips_decode dc(alu_op, rd_src, alu_src2, writeenable, except, opcode, funct);
    assign bus = {16{inst[15]}};
    assign imm32= {bus,inst[15:0]};//sign extension
    mux2v mx2(B,rtData,imm32,alu_src2);



    /* add other modules */





endmodule // arith_machine
