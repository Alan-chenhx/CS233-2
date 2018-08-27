// mips_decode: a decoder for MIPS arithmetic instructions
//
// alu_op       (output) - control signal to be sent to the ALU
// rd_src       (output) - should the destination register be rd (0) or rt (1)
// alu_src2     (output) - should the 2nd ALU source be a register (0) or an immediate (1)
// writeenable  (output) - should a new value be captured by the register file
// except       (output) - set to 1 when we don't recognize an opdcode & funct combination
// control_type (output) - 00 = fallthrough, 01 = branch_target, 10 = jump_target, 11 = jump_register
// mem_read     (output) - the register value written is coming from the memory
// word_we      (output) - we're writing a word's worth of data
// byte_we      (output) - we're only writing a byte's worth of data
// byte_load    (output) - we're doing a byte load
// slt          (output) - the instruction is an slt
// lui          (output) - the instruction is a lui
// addm         (output) - the instruction is an addm
// opcode        (input) - the opcode field from the instruction
// funct         (input) - the function field from the instruction
// zero          (input) - from the ALU
//
`define ALU_ADD    3'h2
`define ALU_SUB    3'h3
`define ALU_AND    3'h4
`define ALU_OR     3'h5
`define ALU_NOR    3'h6
`define ALU_XOR    3'h7
`define OP_J       6'h02
`define OP_BEQ      6'h04
`define OP_BNE      6'h05
`define OP0_SLT     6'h2a
`define OP0_ADDM    6'h2c
`define OP_LUI      6'h0f
`define OP_LB       6'h20
`define OP_LBU      6'h24
`define OP_LW       6'h23
`define OP_SW       6'h2b
`define OP_SB       6'h28
`define OP0_JR      6'h08
`define OP0_SUB     6'h22

// module mips_decode(alu_op, rd_src, alu_src2, writeenable, except, control_type,
//                    mem_read, word_we, byte_we, byte_load, slt, lui, addm,
//                    opcode, funct, zero);
//     output [2:0] alu_op;
//     output       rd_src, alu_src2, writeenable, except;
//     output [1:0] control_type;
//     output       mem_read, word_we, byte_we, byte_load, slt, lui, addm;
//     input  [5:0] opcode, funct;
//     input        zero;
//
//
//     wire temp = opcode == `OP_OTHER0;
//     assign alu_op = (temp&& (funct == `OP0_ADD)||temp&&(funct==`OP0_ADDM)||(opcode==`OP_LW)||(opcode==`OP_SB)||(opcode==`OP_LBU)||(opcode==`OP_SW)) ? `ALU_ADD:
//                     (temp&& (funct == `OP0_SUB)||(opcode==`OP_BEQ)&&zero||(opcode==`OP_BNE)&&~zero||(temp&&funct==`OP0_SLT)) ? `ALU_SUB:
//                     (temp&& (funct == `OP0_AND)) ? `ALU_AND:
//                     (temp&& (funct == `OP0_OR)) ? `ALU_OR:
//                     (temp&& (funct == `OP0_NOR)) ? `ALU_NOR:
//                     (temp&& (funct == `OP0_XOR))? `ALU_XOR:
//                     (opcode==`OP_ADDI) ? `ALU_ADD:
//                     (opcode==`OP_ANDI) ? `ALU_AND:
//                     (opcode==`OP_ORI) ? `ALU_OR:
//                     (opcode==`OP_XORI) ? `ALU_XOR:
//                     3'b000;
//
//     assign except = ~(temp&& (funct == `OP0_ADD)||temp&&(funct==`OP0_ADDM)||(opcode==`OP_LW)||(opcode==`OP_SB)
//                     ||(opcode==`OP_LBU)||(opcode==`OP_SW)||temp&&(funct == `OP0_SUB)||(opcode==`OP_BEQ)
//                     ||(opcode==`OP_BNE)||temp&&(funct==`OP0_SLT)||temp&& (funct == `OP0_AND)||temp&& (funct == `OP0_OR)
//                     ||temp&&(funct == `OP0_NOR)||temp&&(funct == `OP0_XOR)||opcode==`OP_ADDI||opcode==`OP_ANDI||opcode==`OP_ORI
//                     ||opcode==`OP_XORI||opcode==`OP_LUI||opcode==`OP_J||((funct==`OP0_JR)&&temp));
//
//     assign alu_src2 = (opcode==`OP_XORI)||(opcode==`OP_ORI)||(opcode==`OP_ANDI)||(opcode==`OP_ADDI)||opcode==`OP_LW||opcode==`OP_LBU||opcode==`OP_SW||opcode==`OP_SB;
//     assign rd_src = (opcode==`OP_ADDI)||(opcode==`OP_ANDI)||(opcode==`OP_ORI)||(opcode==`OP_XORI)||opcode==`OP_LUI||opcode==`OP_LW||opcode==`OP_LBU;
//     assign writeenable = (temp&& (funct == `OP0_ADD))||opcode==`OP_LUI||(funct==`OP0_SLT)&&temp||opcode==`OP_LW||opcode==`OP_LBU||((funct==`OP0_ADDM)&&temp)
//                     ||(temp&& (funct == `OP0_SUB))||(temp&& (funct == `OP0_AND))||(temp&& (funct == `OP0_OR))||(temp&& (funct == `OP0_NOR))
//                     ||(temp&& (funct == `OP0_XOR))||(opcode==`OP_ADDI)||(opcode==`OP_ANDI)||(opcode==`OP_ORI)||(opcode==`OP_XORI);
//     assign control_type = ((opcode==`OP_J))?2'b10:
//     					 (temp&&(funct==`OP0_JR))?2'b11:
//     					 ((opcode==`OP_BEQ)&&zero)||((opcode==`OP_BNE)&&~zero)?2'b01:
//     					 0;
//     assign slt =  (temp&&(funct==`OP0_SLT));
//     assign lui = (opcode == `OP_LUI);
//     assign addm = (temp&&funct == `OP0_ADDM);
//     assign mem_read = (opcode==`OP_LBU ||opcode==`OP_LW || (funct==`OP0_ADDM)&&temp);
//     assign word_we = (opcode==`OP_SW);
//     assign byte_we = (opcode==`OP_SB);
//     assign byte_load = (opcode==`OP_LBU);
//
// endmodule // mips_decode
module mips_decode(alu_op, rd_src, alu_src2, writeenable, except, control_type,
                   mem_read, word_we, byte_we, byte_load, slt, lui, addm,
                   opcode, funct, zero);
    output [2:0] alu_op;
    output       rd_src, alu_src2, writeenable, except;
    output [1:0] control_type;
    output       mem_read, word_we, byte_we, byte_load, slt, lui, addm;
    input  [5:0] opcode, funct;
    input        zero;

    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    wire add_r, sub_r, and_r, or_r, nor_r, xor_r;
    wire add_i, and_i, or_i, xor_i;
    and a1(add_r, opcode == `OP_OTHER0, funct == `OP0_ADD);
    and a2(sub_r, opcode == `OP_OTHER0, funct == `OP0_SUB);
    and a3(and_r, opcode == `OP_OTHER0, funct == `OP0_AND);
    and a4(or_r, opcode == `OP_OTHER0, funct == `OP0_OR);
    and a5(nor_r, opcode == `OP_OTHER0, funct == `OP0_NOR);
    and a6(xor_r, opcode == `OP_OTHER0, funct == `OP0_XOR);
    and a7(add_i, opcode == `OP_ADDI);
    and a8(and_i, opcode == `OP_ANDI);
    and a9(or_i, opcode == `OP_ORI);
    and a10(xor_i, opcode == `OP_XORI);
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

    wire bne_i, beq_i, lui_i, lw_i, lbu_i, sw_i, sb_i;
    wire j_j;
    wire jr_r, slt_r, addm_r;

    and a11(bne_i, opcode == `OP_BNE);
    and a12(beq_i, opcode == `OP_BEQ);
    and a13(lui_i, opcode == `OP_LUI);
    and a14(lw_i, opcode == `OP_LW);
    and a15(lbu_i, opcode == `OP_LBU);
    and a16(sw_i, opcode == `OP_SW);
    and a17(sb_i, opcode == `OP_SB);

    and a18(j_j, opcode == `OP_J);

    and a19(jr_r, opcode == `OP_OTHER0, funct == `OP0_JR);
    and a20(slt_r, opcode == `OP_OTHER0, funct == `OP0_SLT);
    and a21(addm_r, opcode == `OP_OTHER0, funct == `OP0_ADDM);

    or o1(alu_op[0], sub_r, or_r, or_i, xor_r, xor_i, beq_i, bne_i, slt_r);
    or o2(alu_op[1], add_r , add_i , sub_r , nor_r , xor_r , xor_i, beq_i, bne_i, slt_r, lw_i, lbu_i, sw_i, sb_i);
    or o3(alu_op[2], and_r , and_i , or_r , or_i , nor_r , xor_r , xor_i);

    or o4(rd_src, lui_i, lw_i, lbu_i, add_i, and_i, or_i, xor_i);
    or o5(alu_src2, lw_i, lbu_i, sw_i, sb_i, rd_src);
    or o6(writeenable, lui_i, slt_r, lw_i, lbu_i, addm_r, add_r, sub_r, and_r, or_r, nor_r, xor_r, add_i, and_i, or_i, xor_i);
    wire any_op;
    or o100(any_op, add_r, sub_r, and_r, or_r, nor_r, xor_r, add_i, and_i, or_i, xor_i, bne_i, beq_i, lui_i, lw_i, lbu_i, sw_i, sb_i, j_j, jr_r, slt_r, addm_r);
    not n1(except, any_op);

    wire beq_ctrl, bne_ctrl;
    and and_beq(beq_ctrl, beq_i, zero);
    and and_bne(bne_ctrl, bne_i, zero == 0);
    or o7(control_type[0], beq_ctrl, bne_ctrl, jr_r);
    or o8(control_type[1], j_j, jr_r);

    or o9(mem_read, lw_i, lbu_i, addm_r);
    buf b1(word_we, sw_i);
    buf b2(byte_we, sb_i);
    buf b3(byte_load, lbu_i);
    buf b4(slt, slt_r);
    buf b5(lui, lui_i);
    buf b6(addm, addm_r);

endmodule // mips_decode
