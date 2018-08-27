// full_machine: execute a series of MIPS instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clock   (input) - the clock signal
// reset   (input) - set to 1 to set all registers to zero, set to 0 for normal execution.

module full_machine(except, clock, reset);
    output      except;
    input       clock, reset;

    wire [31:0] inst;
    wire [31:0] PC,nextPC;
    wire [31:0] B,imm32;//B
    wire [2:0] alu_op;//alu1_out
    wire [31:0]alu1_out;
    wire [15:0] bus;
    wire [4:0] rdNum;
    wire writeenable,rd_src,alu_src2;
    wire [5:0]opcode;
    wire [5:0]funct;
    wire [31:0] rsData,out,rdData,rtData;
    wire zero,negative,overflow;
    wire mem_read, word_we, byte_we, byte_load, slt, lui, addm,true_slt_signal;
    wire[1:0] control_type;//control_type

    wire [31:0]data_out,addr,data_in;
    wire [31:0]next_op,jr_out,j_out,branch_out,branch_offset;//control wires

    wire[31:0]lb_out,lb_extend;//load_byte
    wire[7:0]byte_out;

    wire[31:0]mem_read_out;//mem_read

    wire[31:0]lui_in,lui_out;//lui

    wire[31:0]addm_out,addm_final;//addm and mem_read

    wire [31:0]slt_out,slt_in;//slt
    wire true_negative;
    assign opcode = inst[31:26];
    assign funct = inst[5:0];




    alu32 al(next_op,,,,PC,32'h4,`ALU_ADD);

    register #(32) PC_reg(PC, nextPC, clock, 1'b1, reset);

    instruction_memory im(inst, PC[31:2]);

     regfile rf (rsData,rtData,inst[25:21], inst[20:16], rdNum, lui_out,writeenable, clock, reset);
     alu32 al1(alu1_out,zero, negative, overflow, rsData, B, alu_op);
     mips_decode dc(alu_op, rd_src, alu_src2, writeenable, except, control_type,
                    mem_read, word_we, byte_we, byte_load, slt, lui, addm,
                    opcode, funct, zero);
     assign bus = {16{inst[15]}};
     assign imm32= {bus,inst[15:0]};//sign extension
     mux2v mx2(B,rtData,imm32,alu_src2);
     mux2v #(5) mx1(rdNum,inst[15:11],inst[20:16],rd_src);

     data_mem data_mem(data_out,addr, rtData, word_we, byte_we, clock, reset);

     mux4v #(8) mx_load_byte1(byte_out,data_out[7:0],data_out[15:8],data_out[23:16],data_out[31:24],alu1_out[1:0]);
     assign lb_extend = {{24{1'b0}},byte_out};
     mux2v mx_load_byte2(lb_out,data_out,lb_extend,byte_load);//load_byte

     mux2v helper_slt(true_negative,negative,~negative,(slt&&overflow));
     assign slt_in = {{31{1'b0}},true_negative};
     mux2v mx_slt(slt_out,alu1_out,slt_in,slt);//slt

     mux2v mx_mem_read(mem_read_out,slt_out,lb_out,mem_read);

     assign lui_in = {inst[15:0],{16{1'b0}}};
     mux2v mx_lui(lui_out,addm_final,lui_in,lui);//lui

     assign branch_offset = {imm32[29:0],{2'b00}};//branch left_sift
     alu32 alu_branch(branch_out,,,,next_op,branch_offset,`ALU_ADD);//branch

     assign j_out = {PC[31:28],inst[27:0],{2'b00}};//j_out
     assign jr_out = rsData;//jr_out

     mux4v mx_control_type(nextPC,next_op,branch_out,j_out,jr_out,control_type);//control_type

     alu32 alu_addm(addm_out,,,,mem_read_out,rtData,`ALU_ADD);
     mux2v mx_addm(addr,alu1_out,rsData,addm);
     mux2v mx_addMfianl(addm_final,mem_read_out,addm_out,addm);

endmodule // full_machine
