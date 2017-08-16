
module button_led_top(
	input	wire			i_clk,
	input	wire			i_btn0,	// Increment
	input	wire			i_btn1,	// Decrement
	input	wire			i_sw0,	// Mode
	output	wire	[15:0]	o_leds  // LED outputs
);

	parameter	SLOW_CLK_PERIOD = 6250000;

	wire	btn0_db = 0;
	wire 	btn1_db	= 0;

	// Intantiate the debouncer for sb and sw2
	debouncer #(
		.SLOW_CLK_PERIOD(SLOW_CLK_PERIOD)
	) 
		db1
	(
		.i_clk 		( i_clk   ),
		.i_btn  	( i_btn0  ),
		.o_sp_db	( btn0_db )
	);

	debouncer #(
		.SLOW_CLK_PERIOD(SLOW_CLK_PERIOD)
	) 
		db2 
	(
		.i_clk 		( i_clk   ),
		.i_btn  	( i_btn1  ),
		.o_sp_db 	( btn1_db )
	);


	// Instantiate LED Controller
	led_controller  #(
		.SLOW_CLK_PERIOD(SLOW_CLK_PERIOD)
	) 
		led 
	(
		.i_clk				( i_clk ),
		.i_mode				( i_sw0 ),
		.ud_mode_incr_decr 	( {btn0_db, btn1_db} ),
		.o_leds				( o_leds )
	);

	// Need to ensure button press makes it to led_controller


endmodule