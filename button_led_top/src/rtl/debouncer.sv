
module debouncer(
	input	wire	i_clk,
	input	wire	i_btn,
	output	wire	o_sp_db
);

	parameter SLOW_CLK_PERIOD = 6250000;

	reg		slow_clk;
	reg 	q1;
	reg		q2; 
	wire	dff1_dff2_q;
	wire	dff_slow_clk;

	assign dff_slow_clk = slow_clk;
	assign dff1_dff2_q 	= q1;
	assign o_sp_db 		= q1 & (~q2);

	clock_div #(
		.SLOW_CLK_PERIOD(SLOW_CLK_PERIOD)
	) cd (
		.i_clk(i_clk),
		.o_slowclk(slow_clk)
	);

	dff dff_1 (
		.i_clk(dff_slow_clk),
		.d(i_btn), 
		.q(q1)
	);

	dff dff_2 (
		.i_clk(dff_slow_clk),
		.d(dff1_dff2_q), 
		.q(q2)
	);

endmodule