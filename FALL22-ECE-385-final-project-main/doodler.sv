//-------------------------------------------------------------------------
//    doodler.sv                                                            
//    based on the ball.sv provided in lab6
//    edited by JS and CC
//    used for ECE 385fFA22 final project
//    2022/11/18
//-------------------------------------------------------------------------


module  doodler ( input Clk, Reset, frame_clk,
                  input [9:0] DrawX, DrawY,
				      input [7:0] keycode,
						input [7:0] keycode_ext,
				      input [1:0] doodler_state,
				      input logic collision, //add 22/11/27
						input logic gain,
						output logic drop, //added 12/4
						input [31:0] distance_sum, //added 12/4
						output [9:0] distance, //add 12/3
				      output [2:0] is_doodler,
                  output [9:0]  BallX, BallY, BallS, Ball_Y_Step_out); 
   
    logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion;//, Ball_Size;
	 logic [9:0] Ball_X_Step, Ball_Y_Step;
	 logic [9:0] counter; //add for y counter
    parameter [9:0] Ball_X_Center=320;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center=390;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min=170;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max=469;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max=479;     // Bottommost point on the Y axis
	 parameter [9:0] doodler_size = 10'd35;
	 parameter [9:0] shooting_doodler_size = 10'd39;
   
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Ball
        if (Reset)  // Asynchronous Rese
        begin 
				counter <= 10'd0;
            Ball_Y_Motion <= (~10'd8 + 10'd1); //Ball_Y_Step;
				Ball_X_Motion <= 10'd0; //Ball_X_Step;
				Ball_Y_Pos <= Ball_Y_Center;
				Ball_X_Pos <= Ball_X_Center;
				distance <= 10'd0;
				drop <= 1'b0;
        end
           
        else 
        begin 	
				counter <= counter + 10'd1;
				
				//if ( (Ball_Y_Pos + 10'd17) >= 10'd479)  // Ball is at the bottom edge, BOUNCE!
					//Ball_Y_Motion <= (~10'd8+10'd1);  // 2's complement.
					  
				//else if( (Ball_Y_Pos + (~10'd17+10'd1) )<= 10'd0)  // Ball is at the top edge, BOUNCE!
					//Ball_Y_Motion <= 10'd8;
				if (gain)
					Ball_Y_Motion <= (~10'd15 + 10'd1);
					
				else if ((Ball_Y_Pos + doodler_size ) >= Ball_Y_Max)// && (distance_sum > 15'd10))
					begin
						drop <= 1'b1;
						Ball_Y_Motion <= ~10'd2+ 10'd1;
					end
					
				//else if ((Ball_Y_Pos + (doodler_size-1)/2) >= Ball_Y_Max)
					//Ball_Y_Motion <= ~10'd8 + 10'd1;
					

				
				else if (collision) // collision with stair
					Ball_Y_Motion <= (~10'd8 + 10'd1);	

				else if (counter > 10'd3) //time to change speed
					begin
						counter <= 10'd0;
						Ball_Y_Motion <= (Ball_Y_Motion + 10'd1);
					end	

				//else
					//0=0;
				   //counter <= counter + 10'd1;
					//Ball_Y_Motion <= Ball_Y_Motion;	// nothing happened, update	  
				 
			
				
				if ((keycode[7:0] == 8'h04) || (keycode_ext[7:0] == 8'h04))
					Ball_X_Motion <= (~(10'd2)+10'd1);//A
				else if ((keycode[7:0] == 8'h07) || (keycode_ext[7:0] == 8'h07))
					Ball_X_Motion <= 10'd2;//D
				else
					Ball_X_Motion <= 10'b0;
		
			/*				case (keycode)
					
							8'h04 : begin
								if ( 385==385 ) 
									Ball_X_Motion <= (~(10'd2)+10'd1);//A
								else
									Ball_X_Motion <= 0;
							   end
					        
							8'h07 : begin
								if ( 385==385 )
									Ball_X_Motion <= 10'd2;//D
								else
									Ball_X_Motion <= 0;
							   end 
							default:
								begin
									Ball_X_Motion <= 10'b0;
								end 
							  
							endcase*/
						
				
				
				
			// update ball position 
				 if (Ball_X_Pos >= (Ball_X_Max + (doodler_size-1)/2))
					begin
						//Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);
						Ball_X_Pos <= (Ball_X_Min - (doodler_size-1)/2 + Ball_X_Motion); // from right to left
					end
				 else if (Ball_X_Pos <= (Ball_X_Min - (doodler_size-1)/2))
					begin
						//Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);
						Ball_X_Pos <= (Ball_X_Max + (doodler_size-1)/2 + Ball_X_Motion); // from left to right
					end
				
				 else
					begin
						//Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);  // Update ball position
						Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);
					end
				
				if (Ball_Y_Pos <= 10'd239 && Ball_Y_Motion > 10'd30)
					begin
						Ball_Y_Pos <= Ball_Y_Pos ;
						distance <= Ball_Y_Motion;
					end
				
				
				else if (drop)
					begin
						Ball_Y_Pos <= Ball_Y_Pos ;
						distance <= 10'd9;
					end
				
				else 
					begin
						Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);
						distance <= 10'd0;
					end
		end
	  /**************************************************************************************
	    ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
		 Hidden Question #2/2:
          Note that Ball_Y_Motion in the above statement may have been changed at the same clock edge
          that is causing the assignment of Ball_Y_pos.  Will the new value of Ball_Y_Motion be used,
          or the old?  How will this impact behavior of the ball during a bounce, and how might that 
          interact with a response to a keypress?  Can you fix it?  Give an answer in your Post-Lab.
      **************************************************************************************/
      
			
		end  

	 
	 
	 //////////// is doodler //////////////
	 int hf_size; // doodler size
	 int hf_s_size; // shooting size
	 int dis_dx, dis_dy;
	 
	 assign dis_dx = DrawX - Ball_X_Pos;
	 assign dis_dy = DrawY - Ball_Y_Pos;
	 assign hf_size = (doodler_size-1)/2;  
	 assign hf_s_size = (shooting_doodler_size-1)/2;
	 
	 always_comb
		begin
			case (doodler_state)
			
			2'b00:
				if ((dis_dx >= -hf_size && dis_dx <= hf_size) && 
				    (dis_dy >= -hf_size && dis_dy <= hf_size))
					is_doodler = 3'b001;
				else
					is_doodler =3'b000;
					
			2'b01:
				if ((dis_dx >= -hf_size && dis_dx <= hf_size) && 
				    (dis_dy >= -hf_size && dis_dy <= hf_size))
					is_doodler = 3'b010;
				else
					is_doodler =3'b000;
					
			2'b10:
				if ((dis_dx >= -hf_size && dis_dx <= hf_size) && 
				    (dis_dy >= -hf_s_size && dis_dy <= hf_s_size))
					is_doodler = 3'b100;
				else
					is_doodler =3'b000;
			default: 
					is_doodler =3'b000;
			
			/*
			2'b00:
				if ((dis_dx >= (~hf_size+1'b1) && dis_dx <= hf_size) && 
				    (dis_dy >= (~hf_size+1'b1) && dis_dy <= hf_size))
					is_doodler = 3'b001;
				else
					is_doodler =3'b000;
					
			2'b01:
				if ((dis_dx >= (~hf_size+1'b1) && dis_dx <= hf_size) && 
				    (dis_dy >= (~hf_size+1'b1) && dis_dy <= hf_size))
					is_doodler = 3'b010;
				else
					is_doodler =3'b000;
					
			2'b10:
				if ((dis_dx >= (~hf_size+1'b1) && dis_dx <= hf_size) && 
				    (dis_dy >= (~hf_s_size+1'b1) && dis_dy <= hf_s_size))
					is_doodler = 3'b100;
				else
					is_doodler =3'b000;
			default: 
					is_doodler =3'b000;
			*/
		endcase
		end
	 
	 
    ////////////// output ////////////////  
    assign BallX = Ball_X_Pos;
   
    assign BallY = Ball_Y_Pos;
   
    assign BallS = (doodler_size-1)/2;
	 
	 assign Ball_Y_Step_out = Ball_Y_Motion; // add for gm???
    

endmodule


















