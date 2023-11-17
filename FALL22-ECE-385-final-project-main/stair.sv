
// stair.sv
// used for final project
// created 22/11/10

module stair( 
				 input Reset, Clk, frame_clk,
				 input [9:0] DrawX, DrawY,
				 output [13:0][9:0] Stair_X, Stair_Y,
				 output [13:0] find,
				 output logic [9:0] stair_size,
				 ///// 22/11/29
				 input [13:0] tool_signal, // add for making sure if springs exists on stairs.
				 output logic [13:0][9:0] toolX, toolY, toolS,
				 input [13:0] move_message, active_message,
				 input [9:0] distance
             );
				 
				 
/////////// local para ////////////


logic check;
assign stair_size = 10'd20;
parameter [9:0] x_max = 10'd469;
parameter [9:0] x_min = 10'd170;
logic [13:0][9:0] stair_x_in;

// moveing stair



// set stair	 
	 always_ff @ (posedge Reset or posedge frame_clk) 
		begin
			if(Reset)		// initiallize
				begin		
				 Stair_X[0] <= 10'd240;
				 Stair_Y[0] <= 10'd30;
				 
				 Stair_X[1] <= 10'd340;
				 Stair_Y[1] <= 10'd60;
				 
				 Stair_X[2] <= 10'd200;
				 Stair_Y[2] <= 10'd90;
				 
				 Stair_X[3] <= 10'd260;
				 Stair_Y[3] <= 10'd120;
				 
				 Stair_X[4] <= 10'd460;
				 Stair_Y[4] <= 10'd150;
				 
				 Stair_X[5] <= 10'd310;
				 Stair_Y[5] <= 10'd180;
				 
				 Stair_X[6] <= 10'd290;
				 Stair_Y[6] <= 10'd210;
				 
				 Stair_X[7] <= 10'd190;
				 Stair_Y[7] <= 10'd240;
	
				 Stair_X[8] <= 10'd360;
				 Stair_Y[8] <= 10'd270;
				 
				 Stair_X[9] <= 10'd270;
				 Stair_Y[9] <= 10'd330;
				 
				 Stair_X[10] <= 10'd280;
				 Stair_Y[10] <= 10'd360;
				 
				 Stair_X[11] <= 10'd390;
				 Stair_Y[11] <= 10'd390;
				 
				 Stair_X[12] <= 10'd320;
				 Stair_Y[12] <= 10'd420;
				 
				 Stair_X[13] <= 10'd310;
				 Stair_Y[13] <= 10'd450;
				  
				 for (int j = 0; j < 14; j++)
				 begin
					if (Stair_X[j] + stair_size >= x_max)
						stair_x_in[j] <= -1;
					else if (Stair_X[j] - stair_size <= x_min)
						stair_x_in[j] <= 1;
					else
						stair_x_in[j] <= 1;
				 end
				 
			end
			
		else
			begin
			   for (int j = 0; j < 14; j++)
					begin
				
						if (Stair_X[j] + stair_size >= x_max)
							stair_x_in[j] <= -1;
						else if (Stair_X[j] - stair_size <= x_min)
							stair_x_in[j] <= 1;
						else
							stair_x_in[j] <= stair_x_in[j];
					
					end

				for (int i = 0; i < 14; i++)
					begin
						Stair_Y[i] <= Stair_Y[i] - distance;
						
						if(Stair_Y[i] > 10'd479)
							begin
								if(active_message[i])
									begin
										//Stair_X[i] <= random_num[9:0];
										Stair_Y[i] <= 10'd0;
									end
								else
									begin
										Stair_X[i] <= 10'd600;
										Stair_Y[i] <= 10'd600;
									end
							end
					
					end
					
					for (int k = 0; k < 14; k++)
						begin
							if (move_message[k])
								Stair_X[k] <= stair_x_in[k] + Stair_X[k];
						end
			end
		end
		
	     
		
		always_comb
			begin
				for (int i = 0; i < 14; i++)
					begin
						find[i] = (    DrawX <= (Stair_X[i] + 10'd20) 
						            && DrawX >= (Stair_X[i] + (~10'd19 + 10'b1))
										&& DrawY <= (Stair_Y[i] + 10'd5)
										&& DrawY >= (Stair_Y[i] + (~10'd4 + 10'b1)));
					end
		   end
		
		/////////////////// add springs for stairs////////////
		always_comb
			begin
				for (int j = 0; j < 14; j++)
					begin
						if (tool_signal[j])
						begin
							toolX[j] = Stair_X[j];
							toolY[j] = Stair_Y[j] - 10'd10;  // tool center is the real center.
							toolS[j] = 10'd7; // Size number?
						end

						else
						begin
							toolX[j] = Stair_X[j];
							toolY[j] = Stair_Y[j] - 10'd10;  // tool center is the real center.
							toolS[j] = 10'd0;
						end
					
					end
			end


			
endmodule			
			
			
		
		
		
		
		
		
				
		
		
		
		
		
		