module pipelined_machine(clk, reset);
    input        clk, reset;

    wire [31:0]  PC;
    wire [31:2]  next_PC, PC_plus4, PC_target;
    wire [31:0]  inst;

    wire [31:0]  imm = {{ 16{IF_DE_instruction[15]} }, IF_DE_instruction[15:0] };  // sign-extended immediate
    wire [4:0]   rs = IF_DE_instruction[25:21];
    wire [4:0]   rt = IF_DE_instruction[20:16];
    wire [4:0]   rd = IF_DE_instruction[15:11];
    wire [5:0]   opcode = IF_DE_instruction[31:26];
    wire [5:0]   funct = IF_DE_instruction[5:0];

    wire [4:0]   wr_regnum;
    wire [2:0]   ALUOp;

    wire         RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, RegDst;
    wire         PCSrc, zero;
    wire [31:0]  rd1_data, rd2_data, B_data, alu_out_data, load_data, wr_data;

    wire DE_MW_Mem_read, DE_MW_Mem_wr, DE_MW_MemtoReg,DE_MW_Regwrite,ForwardA,stall,ForwardB,stalling;
    wire [4:0] DE_MW_wrreg;
    wire [31:0] IF_DE_instruction,DE_MW_alu_result,DE_MW_rd2,final_alu_rd1,final_alu_rd2;
    wire [31:2] IF_DE_PC;
    // DO NOT comment out or rename this module
    // or the test bench will break

    //mux2v #(30) pc_mux(pc_stall,next_PC[31:2], PC[31:2],stall);
    register #(30, 30'h100000) PC_reg(PC[31:2], next_PC[31:2], clk, /* enable */~stall, reset);

    assign PC[1:0] = 2'b0;  // bottom bits hard coded to 00
    adder30 next_PC_adder(PC_plus4, PC[31:2], 30'h1);
    adder30 target_PC_adder(PC_target, IF_DE_PC, imm[29:0]);
    mux2v #(30) branch_mux(next_PC, PC_plus4, PC_target, PCSrc);
    assign PCSrc = BEQ & zero;

    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory imem(inst, PC[31:2]);

    mips_decode decode(ALUOp, RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, RegDst,
                      opcode, funct);

    // DO NOT comment out or rename this module
    // or the test bench will break
    regfile rf (rd1_data, rd2_data,
               rs, rt, DE_MW_wrreg, wr_data,
               DE_MW_Regwrite, clk, reset);

    mux2v #(32) imm_mux(B_data, final_alu_rd2, imm, ALUSrc);
    alu32 alu(alu_out_data, zero, ALUOp, final_alu_rd1, B_data);

    // DO NOT comment out or rename this module
    // or the test bench will break
    data_mem data_memory(load_data, DE_MW_alu_result, DE_MW_rd2, DE_MW_Mem_read, DE_MW_Mem_wr, clk, reset);

    mux2v #(32) wb_mux(wr_data, DE_MW_alu_result, load_data, DE_MW_MemtoReg);
    mux2v #(5) rd_mux(wr_regnum, rt, rd, RegDst);

    register #(30,)IF_DE_PCadd(IF_DE_PC, PC_plus4, clk, ~stall, reset||PCSrc);
    register #(32,)IF_DE_inst(IF_DE_instruction,inst,clk,~stall,reset||PCSrc);
    register #(32,)DE_MW_alu(DE_MW_alu_result,alu_out_data,clk,1'b1, reset);
    register #(32,)DE_MW_rd2_data(DE_MW_rd2,final_alu_rd2,clk,1'b1,reset);
    register #(5,)DE_MW_WR_reg(DE_MW_wrreg,wr_regnum,clk,1'b1,reset);
    register #(1,)DE_MW_memread(DE_MW_Mem_read,MemRead,clk,1'b1,reset);
    register #(1,)DE_MW_memwrite(DE_MW_Mem_wr,MemWrite,clk,1'b1,stall||reset);
    register #(1,)DE_MW_memtoreg(DE_MW_MemtoReg,MemToReg,clk,1'b1,reset);
    register #(1,)DE_MW_Regwr(DE_MW_Regwrite,RegWrite,clk,1'b1,reset||stall);

    assign ForwardA = DE_MW_Regwrite && (rs==DE_MW_wrreg) && (DE_MW_wrreg != 5'b0);
    assign ForwardB = DE_MW_Regwrite && (rt==DE_MW_wrreg) && (DE_MW_wrreg != 5'b0);
    //register #(1) stalling_reg(stalling, stall, clk, 1'b1, reset);
    assign stall = DE_MW_Mem_read && ((DE_MW_wrreg==rs)||(DE_MW_wrreg==rt)) && (DE_MW_wrreg != 5'b0) && opcode==6'h4 /*&&  ~(stalling & (opcode == 6'h23))*/;
    //assign ForwardC = DE_MW_Regwrite && ()
    mux2v #(32)FwdA(final_alu_rd1,rd1_data,DE_MW_alu_result,ForwardA);
    mux2v #(32)FwdB(final_alu_rd2,rd2_data,DE_MW_alu_result,ForwardB);

endmodule // pipelined_machine
