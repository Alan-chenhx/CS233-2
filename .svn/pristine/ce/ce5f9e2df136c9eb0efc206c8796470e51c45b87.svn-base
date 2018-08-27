module timer(TimerInterrupt, cycle, TimerAddress,
             data, address, MemRead, MemWrite, clock, reset);
    output        TimerInterrupt;
    output [31:0] cycle;
    output        TimerAddress;
    input  [31:0] data, address;
    input         MemRead, MemWrite, clock, reset;
    wire [31:0] Q_inter,Q_counter,alu_out;
    wire        timeRead,timeWrite,acknowledge;


    assign timeRead = MemRead&&(32'hffff001c==address);
    assign timeWrite = MemWrite&&(32'hffff001c==address);
    assign acknowledge = MemWrite&&(address==32'hffff006c);
    assign TimerAddress = (32'hffff001c==address)||(address==32'hffff006c);

    register #(,32'hffffffff) interrupt_cycle(Q_inter,data,clock,timeWrite,reset);
    register cycle_counter(Q_counter,alu_out,clock,1'd1,reset);
    alu32   alu(alu_out,,,`ALU_ADD,Q_counter,32'd1);
    dffe  interupt_line(TimerInterrupt,1'd1,clock,(Q_counter==Q_inter),(acknowledge||reset));
    tristate t(cycle,Q_counter,timeRead);
    // complete the timer circuit here

    // HINT: make your interrupt cycle register reset to 32'hffffffff
    //       (using the reset_value parameter)
    //       to prevent an interrupt being raised the very first cycle
endmodule
