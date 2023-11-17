module  ball ( input Reset, frame_clk, pixel_clk, clk_50,
					input [7:0] keycode,
					input [9:0] DrawX, DrawY,
               output [9:0]  BallX, BallY, BallS, score,
					output lFlag, rFlag, uFlag, dFlag, endFlag, lookDir,
					output sig1, sig2, sig3, sig4, questionFlag,
					output [20:0] logicalX,
					output [9:0] gameTime,
					output [4:0] collisionIndexRight, collisionIndexLeft, collisionIndexUp, collisionIndexDown
					);
    
    logic [9:0] Ball_X_Pos, Ball_Right_Motion, Ball_Left_Motion, Ball_Y_Pos, Ball_Up_Motion, Ball_Down_Motion, Ball_Size;
	 logic [9:0] New_X_Pos, New_Y_Pos;
	 logic downFlag, upFlag, leftFlag, rightFlag, addTrue, jumpReset, beginFlag, backFlag, horizFlag;
	 logic [5:0] jumpCount;
	 logic [2:0] speed, terminal;
	 logic [5:0] fallDownSpeed, fallUpSpeed, NetRight, NetLeft, NetUp, NetDown;
	 logic [5:0] finUp, finDown, finRight, finLeft;
	 logic [9:0] collision_down, collision_up, collision_right, collision_left;
	 logic [5:0] Right_Offset, Left_Offset, Up_Offset, Down_Offset;
	 logic [9:0] X_Out, Y_Out;
	 logic [5:0] gameTimeCounter;
	 
	 
    parameter [9:0] Ball_X_Center=80;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center=100;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max=416;  //was 479 hardcoded floor   // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step=1;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step=1;      // Step size on the Y axis

    assign Ball_Size = 16;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
   
	collisions mario_collisions (.X_Pos(Ball_X_Pos), .Y_Pos(Ball_Y_Pos), 
	.DrawX(DrawX), .DrawY(DrawY), .Right_V(NetRight), .Left_V(NetLeft), .Up_V(NetUp), 
	.Down_V(NetDown), .frame_clk(frame_clk), .pixel_clk(pixel_clk), 
	.clk_50(clk_50), .X_Out(New_X_Pos),.Y_Out(New_Y_Pos), .upFlag(upFlag), 
	.downFlag(downFlag), .rightFlag(rightFlag), .leftFlag(leftFlag),
	.collision_down(collision_down), .collision_up(collision_up), 
	.collision_left(collision_left), .collision_right(collision_right),
	.logicalX(logicalX), .collisionIndexRight(collisionIndexRight), 
	.collisionIndexLeft(collisionIndexLeft), .collisionIndexUp(collisionIndexUp), 
	.collisionIndexDown(collisionIndexDown)
	);
	
	//counter timercounter (.Clk(frame_clk), .count(timecount));
	
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Ball
        if (Reset)  // Asynchronous Reset
        begin 
            Ball_Up_Motion <= 10'd0; //Ball_Y_Step;
				Ball_Down_Motion <= 10'd0; //Ball_Y_Step;
				Ball_Right_Motion <= 10'd0; //Ball_X_Step;
				Ball_Left_Motion <= 10'd0; //Ball_X_Step;
				Ball_Y_Pos <= Ball_Y_Center;
				Ball_X_Pos <= Ball_X_Center;
				jumpCount <= 0;
				speed <= 2;
				terminal <= 3;
				sig1 <= 0;
				sig2 <= 0;
				sig3 <= 0;
				sig4 <= 0;
				beginFlag <= 0;
				logicalX <= 0;
				gameTime <= 600;
				endFlag <= 0;
				score <= 0;
        end
		  else if((gameTime == 0)||(Ball_Y_Pos >= 460))
		  begin
		  Ball_Up_Motion <= 10'd0; //Ball_Y_Step;
				Ball_Down_Motion <= 10'd0; //Ball_Y_Step;
				Ball_Right_Motion <= 10'd0; //Ball_X_Step;
				Ball_Left_Motion <= 10'd0; //Ball_X_Step;
				Ball_Y_Pos <= Ball_Y_Center;
				Ball_X_Pos <= Ball_X_Center;
				jumpCount <= 0;
				speed <= 2;
				terminal <= 3;
				sig1 <= 0;
				sig2 <= 0;
				sig3 <= 0;
				sig4 <= 0;
				beginFlag <= 0;
				logicalX <= 0;
				gameTime <= 600;
				endFlag <= 0;
				//score <= 0;
		  end
		  else if(endFlag)
		  begin
		  //do nothing really, the color_mapper takes over with a victory screen
		  if(gameTime != 0)
		  begin
		  score <= score + 1;
		  gameTime <= gameTime - 1;
		  end
		  if(Ball_Y_Pos <= 400)
			Ball_Y_Pos <= Ball_Y_Pos + 1;
		  end
        else 
        begin 		  
		  
			if((collisionIndexRight == 6)||(collisionIndexLeft == 6)||(collisionIndexUp == 6)||(collisionIndexDown == 6))
				score <= score + 10;
				
			gameTimeCounter <= gameTimeCounter + 1;
			if(gameTimeCounter == 63)
			gameTime <= gameTime-1;
			
			if(Ball_X_Pos >= 620)
			begin
			endFlag <= 1;
			score <= 0;
			end
			
			
		  if(jumpCount == 0)
		  begin
		  
		  
					  
				  
				 begin
					  Ball_Up_Motion <= 0;
					  Ball_Down_Motion <= terminal;
					  Ball_Right_Motion <= 0; // No key is pressed, fall down.
					 Ball_Left_Motion <= 0;
				 
					if((keycode == 8'h04)/*&&!leftFlag*/)
							begin

								Ball_Left_Motion <= speed;//A
								lookDir <= 1;
							  end
					        
					if((keycode == 8'h07)/*&&!rightFlag*/)
							begin
								
								Ball_Right_Motion <= speed;//D
								beginFlag<=1;
								lookDir <= 0;
							  end

							  
					if((keycode == 8'h16)/*&&!downFlag*/)
							begin

								Ball_Down_Motion <= terminal;//S
							 end
							  
					if((keycode == 8'h1A)/*&&!upFlag&&downFlag*/)
							begin
								jumpCount <= 6'b111111;
							 end	  

				end
				end
				else
				begin
				if(jumpCount == 6'b111111)
				begin
				fallUpSpeed <= 9;
				fallDownSpeed <= 4;
				end
				if(jumpCount % 6 == 0)
				begin
				if(fallUpSpeed != 0)
				fallUpSpeed <= fallUpSpeed - 1;
				end
				Ball_Up_Motion <= fallUpSpeed;
				Ball_Down_Motion <= fallDownSpeed;
				jumpCount <= jumpCount - 1;
				if((keycode == 8'h04)/*&&!leftFlag*/)
							begin

								Ball_Left_Motion <= speed;//A
								Ball_Right_Motion <= 0;
								Ball_Up_Motion <= fallUpSpeed;
								Ball_Down_Motion <= fallDownSpeed;
								lookDir <= 1;
							  end
					        
				else if((keycode == 8'h07)/*&&!rightFlag*/)
							begin
								beginFlag<=1;
							  Ball_Left_Motion <= 0;
								Ball_Right_Motion <= speed;//D
								Ball_Up_Motion <= fallUpSpeed;
								Ball_Down_Motion <= fallDownSpeed;
								lookDir <= 0;
							  end

				
				else
				begin
				Ball_Right_Motion <= 0;
				Ball_Left_Motion <= 0;
				end
				end
				 
				 
				 NetRight <= Ball_Right_Motion;
				 NetLeft <= Ball_Left_Motion;
				 NetUp <= Ball_Up_Motion; //+ fallUpSpeed;
				 NetDown <= Ball_Down_Motion; //+ fallDownSpeed;
			 
		if(Ball_Right_Motion > Ball_Left_Motion) 
		begin
		NetRight <= Ball_Right_Motion - Ball_Left_Motion;
		NetLeft <= 0;
		end

	else
		begin
		NetLeft <= Ball_Left_Motion - Ball_Right_Motion;
		NetRight <= 0;
		end

	if(Ball_Up_Motion > Ball_Down_Motion)
		begin
		NetUp <= Ball_Up_Motion - Ball_Down_Motion;
		NetDown <= 0;
		end
	
	else
		begin
		NetDown <= Ball_Down_Motion - Ball_Up_Motion;
		NetUp <= 0;
		end
				 
		if(Ball_X_Pos < 6)
		NetLeft <= 0;
				lFlag <= leftFlag;
				rFlag <= rightFlag;
				uFlag <= upFlag;
				dFlag <= downFlag;
				
	
	//Older collision logic transplanted to ball
	
Right_Offset <= 15;
Left_Offset <= 0;
Up_Offset <= 0;
Down_Offset <= 15;
if(beginFlag)
begin

if((Ball_X_Pos >= 320)&&(logicalX<1420))
begin
backFlag <= 0;
Ball_X_Pos <= 320;
		if(NetRight > NetLeft)
		begin
		finRight <= NetRight - NetLeft;
		if(!(Ball_X_Pos + finRight + 30 > collision_right))
		begin
				logicalX <= logicalX + 1;
				sig1 <= 1;
				end
		end
else if(NetLeft > NetRight)
		backFlag <= 1;
		
		if(NetUp > 0)
		begin
		if(Ball_Y_Pos - NetUp + Up_Offset < collision_up) //possible bug here is getting stuck on ceilings in a jump until timer runs out. Solve by adding a zero output for up Veclocity if this is the case.
			Ball_Y_Pos <= collision_up + 1 + Up_Offset; //maybe remove offset
		else
			Ball_Y_Pos <= Ball_Y_Pos - NetUp;
		end

	else
		begin
		if(Ball_Y_Pos + NetDown + Down_Offset > collision_down)
			Ball_Y_Pos <= collision_down - 1 - Down_Offset; //maybe remove offset
		else
			Ball_Y_Pos <= Ball_Y_Pos + NetDown;
		end	
		

end


if(backFlag || Ball_X_Pos < 320 || logicalX >= 1420)
begin
horizFlag <= 0;
if(NetRight > 0)
		begin
		if(Ball_X_Pos + NetRight + Right_Offset > collision_right)
		begin
			X_Out = collision_right - 1 -Right_Offset; //maybe remove offset
			horizFlag <= 1;
			end
		else
			X_Out = Ball_X_Pos + NetRight;
		end

	else
		begin
		if(Ball_X_Pos - NetLeft + Left_Offset < collision_left)
		begin
			X_Out = collision_left + 1 + Left_Offset; //maybe remove offset
			horizFlag <= 1;
			end
		else
			X_Out = Ball_X_Pos - NetLeft;
		end
if((NetUp > 0))
		begin
		if((Ball_Y_Pos - NetUp + Up_Offset < collision_up)&&(!horizFlag)) //possible bug here is getting stuck on ceilings in a jump until timer runs out. Solve by adding a zero output for up Veclocity if this is the case.
			Y_Out = collision_up + 1 + Up_Offset; //maybe remove offset
		else
			Y_Out = Ball_Y_Pos - NetUp;
		end

	else
		begin
		if((Ball_Y_Pos + NetDown + Down_Offset > collision_down))
			Y_Out = collision_down - 1 - Down_Offset; //maybe remove offset
		else
			Y_Out = Ball_Y_Pos + NetDown;
		end	
				
	
	
	
	if(beginFlag)
	begin
		Ball_X_Pos <= X_Out;
		Ball_Y_Pos <= Y_Out;
		end
		else
		begin
		Ball_X_Pos <= Ball_X_Pos;
		Ball_Y_Pos <= Ball_Y_Pos;
		end
			
		end 
	end	
		end
    end
       
    assign BallX = Ball_X_Pos;
   
    assign BallY = Ball_Y_Pos;
   
    assign BallS = Ball_Size;
    
	 

endmodule
