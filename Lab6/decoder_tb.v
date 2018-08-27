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

module decoder_test;
    reg [5:0] opcode, funct;
    reg       zero  = 0;

    initial begin
        $dumpfile("decoder.vcd");
        $dumpvars(0, decoder_test);

        // remember that all your instructions from last week should still work
             opcode = `OP_OTHER0; funct = `OP0_ADD; // see if addition still works
        # 10 opcode = `OP_OTHER0; funct = `OP0_SUB; // see if subtraction still works
        # 10 opcode = `OP_OTHER0; funct = `OP0_SLT;
        # 10 opcode = `OP_J; funct = `OP_OTHER0;
        # 10 opcode = `OP_OTHER0; funct = `OP0_ADDM;
        # 10 opcode = `OP_LUI; funct = `OP_OTHER0;
        # 10 opcode = `OP_LBU; funct = `OP_OTHER0;
        # 10 opcode = `OP_LW; funct = `OP_OTHER0;
        # 10 opcode = `OP_SW; funct = `OP_OTHER0;
        # 10 opcode = `OP_SB; funct = `OP_OTHER0;
        # 10 opcode = `OP_OTHER0; funct = `OP0_JR;
        # 10 opcode = `OP_OTHER0; funct = 6'b000010;
        // test all of the others here
        
        // as should all the new instructions from this week
        # 10 opcode = `OP_BEQ; zero = 0; // try a not taken beq
        # 10 opcode = `OP_BEQ; zero = 1; // try a taken beq
        // add more tests here!

        # 10 $finish;
    end

    // use gtkwave to test correctness
    wire [2:0] alu_op;
    wire       rd_src, alu_src2, writeenable, except;
    wire [1:0] control_type;
    wire       mem_read, word_we, byte_we, byte_load, slt, lui, addm;
    mips_decode decoder(alu_op, rd_src, alu_src2, writeenable, except, control_type,
                        mem_read, word_we, byte_we, byte_load, slt, lui, addm,
                        opcode, funct, zero);
endmodule // decoder_test
