

module LED_tb ();

	reg clk;
	reg	[15:0] leds;

	initial begin
		clk = 0;
		forever begin
			#2;
			clk=~clk;
		end
	end

	LED_top dut(
		.i_clk(clk),
		.o_leds(leds)
	);

endmodule