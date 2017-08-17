


module led_controller (
	input	wire            i_clk,

	input	wire			i_mode,				// 0 : 'Sine Mode'
												// 1 : 'Up/Down Mode'

	input   wire	[1:0]	ud_mode_incr_decr,	// 01 : Increment
												// 10 : Decrement
												
	output 	reg     [15:0]  o_leds
);

	parameter	COUNT_IDLE			= 0;
	parameter	COUNT_ACTIVE		= 1;
	parameter	COUNT_RESET			= 2;

	parameter 	SINE_MODE			= 0;
	parameter	UPDOWN_MODE			= 1;

	parameter 	SINEMODE_LED_INCR	= 0;
	parameter 	SINEMODE_LED_DECR	= 1;

	parameter 	UDMODE_INCR 		= 2'b01;
	parameter 	UDMODE_DECR 		= 2'b10;

	parameter	SLOW_CLK_PERIOD			= 6250000;
	parameter 	PERIOD_CHANGE_AMOUNT	=  500000;

	reg		[1:0]	count_state	 	= COUNT_IDLE;
	reg		[36:0]	count;

	reg				sinemode_led_state	= SINEMODE_LED_INCR;
	reg				updown_led_state	= UDMODE_INCR;
	reg		[3:0]	sine_led_data 		= 4'h7;
	reg		[3:0]	updown_led_data		= 4'h7;


	reg				update_leds 		= 0;

	reg		[40:0]	update_period 		= (i_mode)? SLOW_CLK_PERIOD : update_period_next;  
	reg		[40:0]	update_period_next	= SLOW_CLK_PERIOD;  


	// LED Output
	always @(posedge i_clk) begin
		case(i_mode)

			SINE_MODE : begin
				case (sine_led_data)
					4'h0 : o_leds <= 16'b0000000011111111;
					4'h1 : o_leds <= 16'b0000000011111110;
					4'h2 : o_leds <= 16'b0000000011111100;
					4'h3 : o_leds <= 16'b0000000011111000;
					4'h4 : o_leds <= 16'b0000000011110000;
					4'h5 : o_leds <= 16'b0000000011100000;
					4'h6 : o_leds <= 16'b0000000011000000;
					4'h7 : o_leds <= 16'b0000000010000000;
					4'h8 : o_leds <= 16'b0000000100000000;
					4'h9 : o_leds <= 16'b0000001100000000;
					4'hA : o_leds <= 16'b0000011100000000;
					4'hB : o_leds <= 16'b0000111100000000;
					4'hC : o_leds <= 16'b0001111100000000;
					4'hD : o_leds <= 16'b0011111100000000;
					4'hE : o_leds <= 16'b0111111100000000;
					4'hF : o_leds <= 16'b1111111100000000;
				endcase
			end

			UPDOWN_MODE : begin
				case(updown_led_data)
					4'h0 : o_leds <= 16'b0000000000000000;
					4'h1 : o_leds <= 16'b1000000000000000;
					4'h2 : o_leds <= 16'b1100000000000000;
					4'h3 : o_leds <= 16'b1110000000000000;
					4'h4 : o_leds <= 16'b1111000000000000;
					4'h5 : o_leds <= 16'b1111100000000000;
					4'h6 : o_leds <= 16'b1111110000000000;
					4'h7 : o_leds <= 16'b1111111000000000;
					4'h8 : o_leds <= 16'b1111111100000000;
					4'h9 : o_leds <= 16'b1111111110000000;
					4'hA : o_leds <= 16'b1111111111000000;
					4'hB : o_leds <= 16'b1111111111100000;
					4'hC : o_leds <= 16'b1111111111110000;
					4'hD : o_leds <= 16'b1111111111111000;
					4'hE : o_leds <= 16'b1111111111111100;
					4'hF : o_leds <= 16'b1111111111111111;
				endcase
			end

		endcase
	end

	// i_clk to led rate SM
	always @(posedge i_clk) begin
		count <= 36'h0;
		case(count_state)

			COUNT_IDLE : begin
				count <= 36'h0;
				count_state <= COUNT_ACTIVE;
			end

			COUNT_ACTIVE : begin
				update_leds <= 0;
				if(count == update_period) begin
					count <= 36'h0;
					update_leds <= 1;
				end
				else begin
					count <= count + 1;
				end
			end

			COUNT_RESET : begin
				count <= 16'h0000;
				count_state <= COUNT_ACTIVE;
			end

		endcase
	end

	// SINE Mode State Machine
	always @(posedge i_clk) begin
		if(update_leds && (i_mode == SINE_MODE)) begin

			case(sinemode_led_state) 

				SINEMODE_LED_INCR : begin
					sinemode_led_state <= SINEMODE_LED_INCR;
					if(sine_led_data == 4'hF) begin
						sinemode_led_state <= SINEMODE_LED_DECR;
						sine_led_data <= 4'hE;
					end
					else begin
						sine_led_data <= sine_led_data + 1;
					end
				end

				SINEMODE_LED_DECR : begin
					sinemode_led_state <= SINEMODE_LED_DECR;
					if(sine_led_data == 4'h0) begin
						sinemode_led_state <= SINEMODE_LED_INCR;
						sine_led_data <= 4'h1;
					end
					else begin
						sine_led_data <= sine_led_data - 1;
					end
				end

			endcase 

		end
	end

	// State machine to handle button presses up/down
	always @(posedge i_clk) begin
		if(update_leds && (i_mode == UPDOWN_MODE)) begin

			case (ud_mode_incr_decr) // Synchronized at top level

				UDMODE_INCR : begin
					updown_led_data <= updown_led_data;
					if(updown_led_data < 4'hF)
						updown_led_data <= updown_led_data + 1;	
				end

				UDMODE_DECR: begin
					updown_led_data <= updown_led_data;
					if(updown_led_data > 4'h0)
						updown_led_data <= updown_led_data - 1;
				end

				default : begin
					updown_led_data <= updown_led_data;
				end

			endcase

		end
		else if(update_leds && (i_mode == SINE_MODE)) begin
			case (ud_mode_incr_decr) // Synchronized at top level

				UDMODE_INCR : begin
					update_period_next <= update_period;
					if( (update_period - PERIOD_CHANGE_AMOUNT) > 0 )
						update_period_next <= update_period - PERIOD_CHANGE_AMOUNT;
				end

				UDMODE_DECR: begin
					update_period_next <= update_period;
					if( (update_period + PERIOD_CHANGE_AMOUNT) < (SLOW_CLK_PERIOD << 5) )
						update_period_next <= update_period + PERIOD_CHANGE_AMOUNT;
				end

				default : begin
					update_period_next <= update_period;
				end

			endcase
		end
	end

endmodule