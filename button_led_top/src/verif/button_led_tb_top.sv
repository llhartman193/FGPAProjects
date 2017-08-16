
module button_led_tb_top();

	reg				clk;
	reg				btn0;	// Increment
	reg				btn1;	// Decrement
	reg				sw0;	// Mode
	reg		[15:0]	leds;  // LED outputs

	initial begin
		clk = 0;
		btn0 = 0;
		btn1 = 0;
		sw0 = 0;

		forever begin
			#2;
			clk = ~clk;
		end

	end

	initial begin
		repeat(100)
			@(posedge clk);

		//sw0 = 1;
		repeat(100)
			@(posedge clk);

		//btn0 = 1;
		repeat(100)
			@(posedge clk);
		
		//btn0 = 0;
		//btn1 = 1;
		repeat(100)
			@(posedge clk);

	end

	button_led_top #(
		.SLOW_CLK_PERIOD(5)
	) 
		dut
	(
		.i_clk(clk),
		.i_btn0(btn0),	// Increment
		.i_btn1(btn1),	// Decrement
		.i_sw0(sw0),	// Mode
		.o_leds(leds)  // LED outputs

	);

endmodule