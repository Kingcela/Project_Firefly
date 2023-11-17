

module collisions (
	input [9:0] X_Pos, Y_Pos, DrawX, DrawY, //input positions
	input [5:0] Right_V, Left_V, Up_V, Down_V, //input velocities
	input frame_clk, pixel_clk, clk_50,
	input [20:0] logicalX,
	output [9:0] X_Out, Y_Out, //output positions
	output rightFlag, leftFlag, downFlag, upFlag, dieFlag, fuleFlag,
	output [9:0] collision_down, collision_up, collision_right, collision_left,
	output [4:0] collisionIndexRight, collisionIndexLeft, collisionIndexUp, collisionIndexDown, sprite_ADDR
	


);


world_rom world_ROM_collisions (.read_address(cell_ADDR), .Clk(clk_50), .data_Out(sprite_ADDR));

always_ff @ (posedge pixel_clk)
begin

	if ((sprite_ADDR%5'h0e == 0))
		begin
			if ((DrawX >= X_Pos - 10) && (DrawX < X_Pos + 35) && (DrawY >= Y_Pos - 20) && (DrawY < Y_Pos + 40))
				dieFlag <= 1;
			else
				dieFlag <= 0;
		end
		
	if ((sprite_ADDR%5'h1b == 0))
		begin
			if ((DrawX >= X_Pos - 10) && (DrawX < X_Pos + 35) && (DrawY >= Y_Pos - 20) && (DrawY < Y_Pos + 40))
				fuleFlag <= 1;
			else
				fuleFlag <= 0;
		end

end

//The location of the nearest colliding pixel in each direction


//Net velocities for each direction because we don't handle negatives
logic [5:0] Net_Right_V, Net_Left_V, Net_Up_V, Net_Down_V;

//The offsets from the top left pixel
logic [5:0] Right_Offset, Left_Offset, Up_Offset, Down_Offset;

logic [10:0] ac;

logic [13:0] cell_ADDR;
//logic [4:0] sprite_ADDR;
logic [9:0] tempX, tempY;

assign Right_Offset = 30;
assign Left_Offset = 0;
assign Up_Offset = 0;
assign Down_Offset = 30;

always_ff @ (posedge pixel_clk)
begin


if((DrawX==0)&&(DrawY==0))											
	begin
	
	Net_Right_V <= 0;
	Net_Left_V <= 0;
	Net_Up_V <= 0;
	Net_Down_V <= 0;


/*--------------------------------------
Set Net velocities because no 2's comp
----------------------------------------*/
	if(Right_V > Left_V) 
		begin
		Net_Right_V <= Right_V - Left_V;
		Net_Left_V <= 0;
		end

	else
		begin
		Net_Left_V <= Left_V - Right_V;
		Net_Right_V <= 0;
		end

	if(Up_V > Down_V)
		begin
		Net_Up_V <= Up_V - Down_V;
		Net_Down_V <= 0;
		end
	
	else
		begin
		Net_Down_V <= Down_V - Up_V;
		Net_Up_V <= 0;
		end
		
		

/*--------------------------------------
Update positions based off collisions
----------------------------------------*/

tempX <= X_Pos + 36;
cell_ADDR <= (tempX[9:4] + logicalX/6)%40 + Y_Pos[9:4]*40 + (tempX[9:4] + logicalX/6)/40*1200;
collisionIndexRight <= sprite_ADDR;

tempX <= X_Pos -2;
cell_ADDR <= (tempX[9:4] + logicalX/6)%40 + Y_Pos[9:4]*40 + (tempX[9:4] + logicalX/6)/40*1200;
collisionIndexLeft <= sprite_ADDR;


tempX <= X_Pos;
tempY <= Y_Pos -2;
cell_ADDR <= (tempX[9:4] + logicalX/6)%40 + tempY[9:4]*40 + (tempX[9:4] + logicalX/6)/40*1200;
collisionIndexUp <= sprite_ADDR;


tempX <= X_Pos;
tempY <= Y_Pos + 36;
cell_ADDR <= (tempX[9:4] + logicalX/6)%40 + tempY[9:4]*40 + (tempX[9:4] + logicalX/6)/40*1200;
collisionIndexDown <= sprite_ADDR;


/*--------------------------------------
Reset all the pixel_clk logic values
----------------------------------------*/
	Net_Right_V <= 0;
	Net_Left_V <= 0;
	Net_Up_V <= 0;
	Net_Down_V <= 0;
	collision_right <= 639;
	collision_left <= 1;
	collision_up <= 0;
	collision_down<= 499;

end //end of the drawX/drawY If statement block



/*--------------------------------------
Determine closest collisions at each pixel
----------------------------------------*/
else 
	begin
	tempX <= DrawX+1;
	cell_ADDR <= (tempX[9:4] + logicalX/6)%40 + DrawY[9:4]*40 + (tempX[9:4] + logicalX/6)/40*1200; //when we do scrolling this will have an logic x offset
	
	if(sprite_ADDR%2 == 0) //even index has collision
		begin
				
			if((DrawY >= Y_Pos)&&(DrawY <= Y_Pos + 5))
				begin
				if((DrawX > X_Pos)&&(DrawX < collision_right))
					begin
						collision_right <= DrawX;
					end
					
				if((DrawX < X_Pos)&&(DrawX > collision_left))
					begin
						collision_left <= DrawX;
					end
					
				end

			if((DrawX >= X_Pos)&&(DrawX <= X_Pos + 15))
				begin
				if((DrawY > Y_Pos)&&(DrawY < collision_down))
					begin
						collision_down <= DrawY;
					end
				if((DrawY < Y_Pos)&&(DrawY > collision_up))
					begin
						collision_up <= DrawY;
					end
					
				end
		
		end	
		
	end
	

end



endmodule
