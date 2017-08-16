
module debouncer(
	input	wire	i_clk,
	input	wire	i_btn,
	output	wire	o_sp_db,
);

	parameter SLOW_CLK_PERIOD = 6250000

	wire	slow_clk;
	wire	q1, q2; 

	assign 	o_sp_db = q1 & (~q2);

	clock_div cd #(
		.SLOW_CLK_PERIOD(SLOW_CLK_PERIOD)
	)
		.i_clk(i_clk),
		.o_slowclk(slow_clk)
	);

	dff dff_1 (
		.i_clk(slow_clk)
		.d(i_btn), 
		.q(q1)
	);

	dff dff_1 (
		.i_clk(slow_clk),
		.d(q1), 
		.q(q2)
	);

endmodule