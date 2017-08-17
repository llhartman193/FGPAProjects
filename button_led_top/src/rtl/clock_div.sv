
module clock_div (
	input	wire	i_clk,
	output	reg		o_slowclk
);

	parameter SLOW_CLK_PERIOD = 6250000;

	reg		[37:0]	counter = 0;

	always @(posedge i_clk) begin
		counter 	<= (counter >= (SLOW_CLK_PERIOD) ) ? 0 : counter + 1;
		o_slowclk 	<= (counter < SLOW_CLK_PERIOD >> 1)?  1'b0 : 1'b1;
	end


endmodule