// monster_state.sv
// created 22/11/24

module monster_state ( input Reset, frame_clk,
							  input [1:0] turn,
							  output logic state								
							 );
							 
////////// local parameter //////////
logic [4:0] delay, next_delay;
//////// end local parameter ////////							 
	
// always_ff @ (posedge Reset or posedge frame_clk)
				
enum logic {right, left} current_state, next_state;

assign state = current_state;

always_ff @ (posedge Reset or posedge frame_clk)
	begin
		if (Reset)
			begin
				current_state <= right;
				delay <= 5'd0;
			end
		else
			begin
				current_state <= next_state;
				delay <= next_delay;
			end		
	end

always_comb
	begin
		next_state = current_state;
		next_delay = 5'd0;
		
		case(current_state)
		
		right:
			if (turn == 2'b01) //touch the right edge, turn left
				next_state = left;
			else
				next_state = right;
				
		left:
			if (turn == 2'b10) //touch the left edge, turn right
				next_state = right;
			else
				next_state = left;
		
		default: next_state = right;
		
		endcase
		
	end
	
	
	
endmodule	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	