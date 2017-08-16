
module dff (
	input	wire	i_clk,
	input	wire	d,
	output	reg		q
);
	
	always @(posedge i_clk) begin
		q <= d;
	end

endmodule