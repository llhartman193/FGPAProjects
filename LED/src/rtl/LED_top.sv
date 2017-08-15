


module LED_top (
	input  wire            i_clk,
	output reg     [15:0]  o_leds
);

	parameter COUNT_IDLE	= 0;
	parameter COUNT_ACTIVE	= 1;
	parameter COUNT_RESET	= 2;
	parameter LED_INCR		= 0;
	parameter LED_DECR		= 1;


	reg		[1:0]	count_state	 	= COUNT_IDLE;
	reg		[36:0]	count;

	reg				led_state		= LED_INCR;
	reg		[3:0]	led_data 		= 0;
	reg				update_leds 	= 0;


	// LED Output
	always @(posedge i_clk) begin
		case (led_data)
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

	always @(posedge i_clk) begin
		count <= 36'h0;
		case(count_state)

			COUNT_IDLE : begin
				count <= 36'h0;
				count_state <= COUNT_ACTIVE;
			end

			COUNT_ACTIVE : begin
				update_leds <= 0;
				if(count == 6250000) begin
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

	always @(posedge i_clk) begin
		if(update_leds) begin
			case(led_state)

				LED_INCR : begin
					led_state <= LED_INCR;
					if(led_data == 4'hF) begin
						led_state <= LED_DECR;
						led_data <= 4'hE;
					end
					else begin
						led_data <= led_data + 1;
					end
				end

				LED_DECR : begin
					led_state <= LED_DECR;
					if(led_data == 4'h0) begin
						led_state <= LED_INCR;
						led_data <= 4'h1;
					end
					else begin
						led_data <= led_data - 1;
					end
				end

			endcase
		end
	end

endmodule