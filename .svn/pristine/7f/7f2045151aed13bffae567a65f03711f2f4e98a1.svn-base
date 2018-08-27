
module palindrome_control(palindrome, done, select, load, go, a_ne_b, front_ge_back, clock, reset);
	output palindrome, done, select, load;
	input go, a_ne_b, front_ge_back;
	input clock, reset;

	wire sGarbage,sStart,sChecking,sAccept,sReject;
	wire sGarbage_next = (sGarbage&~go)|reset;
	wire sStart_next = ((sGarbage & go)|(sStart & go)|(sAccept&go)|(sReject&go))&~reset;
	wire sChecking_next = (sStart & ~go)|(sChecking&~front_ge_back&~a_ne_b)&~reset;
	wire sAccept_next = (sChecking&front_ge_back&~a_ne_b)|(sAccept&~go)&~reset;
	wire sReject_next = (sChecking&~front_ge_back&a_ne_b)|(sReject&~go)&~reset;

	dffe dfGarbage(sGarbage,sGarbage_next,clock,1'b1,1'b0);
	dffe dfstart(sStart,sStart_next,clock,1'b1,1'b0);
	dffe dfchecking(sChecking,sChecking_next,clock,1'b1,1'b0);
	dffe dfaccept(sAccept,sAccept_next,clock,1'b1,1'b0);
	dffe dfreject(sReject,sReject_next,clock,1'b1,1'b0);

	assign done = sReject|sAccept ? 1:0;
	assign select = sChecking ? 1 : 0;
	assign load = sStart|sChecking ? 1 :0 ;
	assign palindrome = sAccept? 1:0;
	
endmodule // palindrome_control 
