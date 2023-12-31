

module collisions (
	input [9:0] X_Pos, Y_Pos, DrawX, DrawY, //input positions
	input [5:0] Right_V, Left_V, Up_V, Down_V, //input velocities
	input frame_clk, pixel_clk, clk_50,
	input [20:0] logicalX,
	output [9:0] X_Out, Y_Out, //output positions
	output rightFlag, leftFlag, downFlag, upFlag,
	output [9:0] collision_down, collision_up, collision_right, collision_left,
	output [4:0] collisionIndexRight, collisionIndexLeft, collisionIndexUp, collisionIndexDown
	


);

world_rom2 world_ROM_collisions (.read_address(cell_ADDR), .Clk(clk_50), .data_Out(sprite_ADDR));

//The location of the nearest colliding pixel in each direction
//logic [9:0] collision_down, collision_up, collision_right, collision_left;

//Net velocities for each direction because we don't handle negatives
logic [5:0] Net_Right_V, Net_Left_V, Net_Up_V, Net_Down_V;

//The offsets from the top left pixel
logic [5:0] Right_Offset, Left_Offset, Up_Offset, Down_Offset;

logic [10:0] ac;

logic [13:0] cell_ADDR;
logic [4:0] sprite_ADDR;
logic [9:0] tempX, tempY;

assign Right_Offset = 15;
assign Left_Offset = 0;
assign Up_Offset = 0;
assign Down_Offset = 15;

always_ff @ (posedge pixel_clk)
begin


if((DrawX==0)&&(DrawY==0)) //initial conditions/update outputs. Happens every frame.
									//I tried at the end (639,479) and also beginning (0,0),
									//but no difference as far as I could tell.
											
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
if(Y_Pos + Net_Down_V + Down_Offset > collision_down)
begin
downFlag <= 1;
end
else
begin
downFlag <= 0;
end

if(X_Pos + Net_Right_V + Right_Offset > collision_right)
begin
rightFlag <= 1;
end
else
begin
rightFlag <= 0;
end

if(Y_Pos - Net_Up_V < collision_up)
begin
upFlag <= 1;
end
else
begin
upFlag <= 0;
end

if(X_Pos - Net_Left_V - Left_Offset < collision_left)
begin
leftFlag <= 1;
end
else
begin
leftFlag <= 0;
end

//if(rightFlag)
//begin
tempX <= X_Pos + 18;
cell_ADDR <= (tempX[9:4] + logicalX/6)%40 + Y_Pos[9:4]*40 + (tempX[9:4] + logicalX/6)/40*1200;
collisionIndexRight <= sprite_ADDR;
//end

//if(leftFlag)
//begin
tempX <= X_Pos -2;
cell_ADDR <= (tempX[9:4] + logicalX/6)%40 + Y_Pos[9:4]*40 + (tempX[9:4] + logicalX/6)/40*1200;
collisionIndexLeft <= sprite_ADDR;
//end

//if(upFlag)
//begin
tempX <= X_Pos;
tempY <= Y_Pos-2;
cell_ADDR <= (tempX[9:4] + logicalX/6)%40 + tempY[9:4]*40 + (tempX[9:4] + logicalX/6)/40*1200;
collisionIndexUp <= sprite_ADDR;
//end

//if(downFlag)
//begin
tempX <= X_Pos;
tempY <= Y_Pos+18;
cell_ADDR <= (tempX[9:4] + logicalX/6)%40 + tempY[9:4]*40 + (tempX[9:4] + logicalX/6)/40*1200;
collisionIndexDown <= sprite_ADDR;
//end

/*--------------------------------------
Reset all the pixel_clk logic values
----------------------------------------*/
	Net_Right_V <= 0;
	Net_Left_V <= 0;
	Net_Up_V <= 0;
	Net_Down_V <= 0;
	collision_right <= 639;
	collision_left <= 0;
	collision_up <= 0;
	collision_down<= 479;

end //end of the drawX/drawY If statement block



/*--------------------------------------
Determine closest collisions at each pixel
----------------------------------------*/
else 
	begin
	tempX <= DrawX+1;
	cell_ADDR <= (tempX[9:4] + logicalX/6)%40 + DrawY[9:4]*40 + (tempX[9:4] + logicalX/6)/40*1200; //when we do scrolling this will have an logic x offset
	

	if(sprite_ADDR[0] == 0) //even index has collision
		begin


		if((DrawY >= Y_Pos)&&(DrawY <= Y_Pos + 5))
			begin
			if((DrawX > X_Pos)&&(DrawX < collision_right))
				collision_right <= DrawX;
			if((DrawX < X_Pos)&&(DrawX > collision_left))
				collision_left <= DrawX;
			end

		if((DrawX >= X_Pos)&&(DrawX <= X_Pos + 15))
			begin
			if((DrawY > Y_Pos)&&(DrawY < collision_down))
				collision_down <= DrawY;
			if((DrawY < Y_Pos)&&(DrawY > collision_up))
				collision_up <= DrawY;
			end

		end
		

	end
	


//have an always_ff @ (posedge frame_clk or posedge VGA_Clk)  <--- Nevermind to this
//go through all the pixels at the pixel_clk, and then at the very
//end (using an if statement for the VGA_Clk) evaluate collisions based
//off of the logic signals generated in pixel_clk. Set the X and Y Out.
//then reset all logic signals for the next frame.

end



endmodule
