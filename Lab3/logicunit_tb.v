module logicunit_test;
    // exhaustively test your logic unit by adapting mux4_tb.v
    // 00 - AND, 01 - OR, 10 - NOR, 11 - XOR
    reg a=0;
    always #1 a = !a;
    reg b=0;
    always #2 b = !b;
    reg [1:0] control = 0;
    wire out;
    logicunit l1(out,a,b,control);
    initial begin
    	$dumpfile("logicunit.vcd");
    	$dumpvars(0,logicunit_test);

    	#4 control = 1;
    	#4 control = 2;
    	#4 control = 3;
    	$finish;
    end

endmodule // logicunit_test
