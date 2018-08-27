module decoder_test;
    reg [5:0] opcode, funct;

    initial begin
        $dumpfile("decoder.vcd");
        $dumpvars(0, decoder_test);

             opcode = `OP_OTHER0; funct = `OP0_ADD; // try addition
        # 10 opcode = `OP_OTHER0; funct = `OP0_SUB; // try subtraction
        // add more tests here!
        # 10 opcode = `OP_OTHER0; funct = `OP0_AND;
        # 10 opcode = `OP_OTHER0; funct = `OP0_OR;
        # 10 opcode = `OP_OTHER0; funct = `OP0_NOR;
        # 10 opcode = `OP_OTHER0; funct = `OP0_XOR;
        # 10 opcode = `OP_ADDI; funct = 6'b101010;
        # 10 opcode = `OP_ANDI; funct = 6'b101010;
        # 10 opcode = `OP_ORI; funct = 6'b101010;
        # 10 opcode = `OP_XORI;funct = 6'b101010;
        # 10 opcode = 6'b110101; funct = 6'b010110;

        # 10 $finish;
    end

    // use gtkwave to test correctness
    wire [2:0] alu_op;
    wire       rd_src, alu_src2, writeenable, except;
    mips_decode decoder(alu_op, rd_src, alu_src2, writeenable, except,
                        opcode, funct);
endmodule // decoder_test

/*
                    (~opcode&& (funct == `OP0_ADD)) ? `ALU_ADD:
                    (~opcode&& (funct == `OP0_SUB)) ? `ALU_SUB:
                    (~opcode&& (funct == `OP0_AND)) ? `ALU_AND:
                    (~opcode&& (funct == `OP0_OR)) ? `ALU_OR:
                    (~opcode&& (funct == `OP0_NOR)) ? `ALU_NOR:
                    (~opcode&& (funct == `OP0_XOR))? `ALU_XOR:
                    (opcode==`OP_ADDI) ? `ALU_ADD:
                    (opcode==`OP_ANDI) ? `ALU_AND:
                    (opcode==`OP_ORI) ? `ALU_OR:
                    (opcode==`OP_XORI) ? `ALU_XOR:
*/