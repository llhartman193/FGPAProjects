
module dff (
	input	wire	i_clk,
	input	wire	d,
	output	reg		q
);

	always @(posedge clk) begin
		d <= q;
	end

endmodule