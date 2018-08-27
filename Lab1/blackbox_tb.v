module blackbox_test;
	reg a,b,c;
	wire cout;
	blackbox bl(cout,a,b,c);
	initial begin
		$dumpfile("blackbox.vcd");
		$dumpvars(0,blackbox_test);

		a=0;b=0;c=0; # 10;
		a=1;b=0;c=0; # 10;
		a=0;b=1;c=0; # 10;
		a=0;b=0;c=1; # 10;
		a=1;b=1;c=0; # 10;
		a=1;b=0;c=1; # 10;
		a=0;b=1;c=1; # 10;
		a=1;b=1;c=1; # 10;
	end
	initial
        $monitor("At time %2t, a = %d b = %d c = %d cout = %d",
                 $time, a, b, c , cout);
endmodule // blackbox_test
