module alu1_test;
    // exhaustively test your 1-bit ALU by adapting mux4_tb.v
    reg a=0;
    always #1 a = !a;
    reg b=0;
    always #2 b = !b;
    reg cin=0;
    always #4 cin = !cin;
    output out,cout;
    reg [2:0] ctl = 0;
    alu1 al(out,cout,a,b,cin,ctl);
    initial begin
    	$dumpfile("alu1.vcd");
    	$dumpvars(0,alu1_test);

    	#8 ctl = 1;
    	#8 ctl = 2;
    	#8 ctl = 3;
    	#8 ctl = 4;
    	#8 ctl = 5;
    	#8 ctl = 6;
    	#8 ctl = 7;
    	$finish;
    end

    initial begin
        $monitor("out:%d cout:%d a:%d b%d cin%d \n",out,cout,a,b,cin);
    end


endmodule
