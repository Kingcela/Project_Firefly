module  color_mapper ( input        [9:0] BallX, BallY, DrawX, DrawY, Ball_size, score,
								input [7:0] keycode,
								input [20:0] logicalX,
								input [9:0] gameTime,
							  input Clk_50,blank,pixel_clk, frame_clk, endFlag, lookDir,
                       output logic [7:0]  Red, Green, Blue );
    
    logic ball_on;
	 logic [9:0] DrawXTemp;
	 logic [3:0] score1_Index, score2_Index, score3_Index;
	 logic [3:0] time1_Index, time2_Index, time3_Index;
	 logic [11:0] score1ADDR, score2ADDR, score3ADDR;
	 logic [11:0] time1ADDR, time2ADDR, time3ADDR;
	 logic [23:0] time1RGB, time2RGB, time3RGB, score1RGB, score2RGB, score3RGB;
	 logic [9:0] time1_x, time2_x, time3_x, time1_y, time2_y, time3_y;
	 logic [9:0] score1_x, score2_x, score3_x, score1_y, score2_y, score3_y;
	 logic time1_on, time2_on, time3_on, score1_on, score2_on, score3_on;
	 
	 // new logic for the status bar
	 logic [9:0] gas_x, gas_y;
	 logic [11:0] gas_addr;
	 logic [23:0] gasRGB;
	 logic gas_on;
	 
	  
    int DistX, DistY, Size;
	 assign DistX = DrawX - BallX;
    assign DistY = DrawY - BallY;
    assign Size = Ball_size;
	 
    always_comb
    begin:Ball_on_proc
    if ((DrawX >= BallX) &&
       (DrawX < BallX + Ball_size) &&
       (DrawY >= BallY) &&
       (DrawY < BallY + Ball_size))
            ball_on = 1'b1;
    else 
            ball_on = 1'b0;
		
		if ((DrawX >= time1_x) &&
       (DrawX < time1_x + 16) &&
       (DrawY >= time1_y) &&
       (DrawY < time1_y + 16))
				time1_on = 1;
		else
				time1_on = 0;
				
		if ((DrawX >= time2_x) &&
       (DrawX < time2_x + 16) &&
       (DrawY >= time2_y) &&
       (DrawY < time2_y + 16))
				time2_on = 1;
		else
				time2_on = 0;
				
		if ((DrawX >= time3_x) &&
       (DrawX < time3_x + 16) &&
       (DrawY >= time3_y) &&
       (DrawY < time3_y + 16))
				time3_on = 1;
		else
				time3_on = 0;
		
		if ((DrawX >= score1_x) &&
       (DrawX < score1_x + 16) &&
       (DrawY >= score1_y) &&
       (DrawY < score1_y + 16))
				score1_on = 1;
		else
				score1_on = 0;
				
				
		if ((DrawX >= score2_x) &&
       (DrawX < score2_x + 16) &&
       (DrawY >= score2_y) &&
       (DrawY < score2_y + 16))
				score2_on = 1;
		else
				score2_on = 0;
				
		if ((DrawX >= score3_x) &&
       (DrawX < score3_x + 16) &&
       (DrawY >= score3_y) &&
       (DrawY < score3_y + 16))
				score3_on = 1;
		else
				score3_on = 0;
				

     end 
  


//RGB to ignore : ee35ff
logic [9:0] sprite_x,sprite_y;
logic [13:0] back_ADDR;
logic [4:0] sprite_Index;
logic [23:0] back_RGB;
logic [12:0] sprite_ADDR;

world_rom world_ROM_Color_Mapper (.read_address(back_ADDR), .Clk(Clk_50), .data_Out(sprite_Index));
	 
palette_16_rom palette_16_rom_mod (.read_address(sprite_ADDR), .Clk(Clk_50), .data_Out(back_RGB));


logic [10:0] mario_ani_ADDR;
logic [23:0] mario_ani_RGB;


mario_ani_rom mario_ani_rom_mod(.read_address(mario_ani_ADDR),.Clk(Clk_50),
									.data_Out(mario_ani_RGB)
);

logic [3:0] mario_ani_count;
logic [1:0] mario_ani_index;
logic add_look,look_dir;

look_dir lookdir_mod(.Clk(frame_clk), .Add_En(add_look),
              .count(look_dir)
);	


// gas_rom
//gas_status_rom gas_rom(.read_address(gas_addr), .Clk(Clk_50), .data_Out(gasRGB));			  
number_rom gas_rom(.read_address(gas_addr), .Clk(Clk_50), .data_Out(gasRGB));

number_rom score1_rom(.read_address(score1ADDR), .Clk(Clk_50), .data_Out(score1RGB)
);
number_rom score2_rom(.read_address(score2ADDR), .Clk(Clk_50), .data_Out(score2RGB)
);
number_rom score3_rom(.read_address(score3ADDR), .Clk(Clk_50), .data_Out(score3RGB)
);

number_rom time1_rom(.read_address(time1ADDR), .Clk(Clk_50), .data_Out(time1RGB)
);
number_rom time2_rom(.read_address(time2ADDR), .Clk(Clk_50), .data_Out(time2RGB)
);
number_rom time3_rom(.read_address(time3ADDR), .Clk(Clk_50), .data_Out(time3RGB)
);

always_comb
begin:sprite_addr_calc
sprite_x = DrawX - BallX;
sprite_y = DrawY - BallY;

DrawXTemp = DrawX+1;
back_ADDR = (DrawXTemp[9:4]+logicalX/6)%40+ DrawY[9:4]*40 + (DrawXTemp[9:4]+logicalX/6)/40*1200;  
sprite_ADDR = (256*sprite_Index + DrawX[3:0]+DrawY[3:0]*16);


score1_Index = score/100;
score2_Index = (score%100)/10;
score3_Index = score%10;

time1_Index = gameTime/100;
time2_Index = (gameTime%100)/10;
time3_Index = gameTime%10;

score1_x = 16;
score2_x = 32;
score3_x = 48;

time1_x = 576;
time2_x = 592;
time3_x = 608;

score1_y = 16;
score2_y = 16;
score3_y = 16;

time1_y = 16;
time2_y = 16;
time3_y = 16;

score1ADDR = 256*score1_Index + DrawX[3:0] + DrawY[3:0]*16;
score2ADDR = 256*score2_Index + DrawX[3:0] + DrawY[3:0]*16;
score3ADDR = 256*score3_Index + DrawX[3:0] + DrawY[3:0]*16;

time1ADDR = 256*time1_Index + DrawX[3:0] + DrawY[3:0]*16;
time2ADDR = 256*time2_Index + DrawX[3:0] + DrawY[3:0]*16;
time3ADDR = 256*time3_Index + DrawX[3:0] + DrawY[3:0]*16;



// address for the gas
gas_x = 400;
gas_y = 6;

gas_addr = 256*12 + DrawX[3:0] + DrawY[3:0]*16;

add_look = 3;
if(keycode == 8'h07) //right
begin
mario_ani_ADDR = 1024*mario_ani_index + sprite_x + sprite_y*32;
add_look = 1;
end

else if(keycode == 8'h04)//left
begin
mario_ani_ADDR = 1024*mario_ani_index +  (30 - sprite_x) + sprite_y*32;
add_look = 0;
end

else if(keycode == 8'h26) //jump
begin
mario_ani_ADDR =  (1024* 2 + 1) + sprite_x + sprite_y*32; //replace with jump mario
end

else
begin
	if(!lookDir)
	begin
	mario_ani_ADDR = sprite_x + sprite_y*32; //mario standing
	end
	else
	begin
	mario_ani_ADDR =(30-sprite_x) + sprite_y*32;
	end
end



//640 by 480 
end





    always_ff @ (posedge pixel_clk)
    begin:RGB_Display
	if(blank == 1)
	begin
        if ((ball_on == 1'b1) && (mario_ani_RGB != 24'hee35ff) ) 
        begin 
            Red <= mario_ani_RGB[23:16];
            Green <= mario_ani_RGB[15:8];
            Blue <= mario_ani_RGB[7:0];
        end
		  else if(time1_on)
		  begin
				Red <= time1RGB[23:16];
            Green <= time1RGB[15:8];
            Blue <= time1RGB[7:0];
		  end
		  else if(time2_on)
		  begin
				Red <= time2RGB[23:16];
            Green <= time2RGB[15:8];
            Blue <= time2RGB[7:0];
		  end
		  else if(time3_on)
		  begin
				Red <= time3RGB[23:16];
            Green <= time3RGB[15:8];
            Blue <= time3RGB[7:0];
		  end
		  else if(score1_on)
		  begin
				Red <= score1RGB[23:16];
            Green <= score1RGB[15:8];
            Blue <= score1RGB[7:0];
		  end
		  else if(score2_on)
		  begin
				Red <= score2RGB[23:16];
            Green <= score2RGB[15:8];
            Blue <= score2RGB[7:0];
		  end
		  else if(score3_on)
		  begin
				Red <= score3RGB[23:16];
            Green <= score3RGB[15:8];
            Blue <= score3RGB[7:0];
		  end
		  else if(gas_on)
		  begin
				Red <= gasRGB[23:16];
            Green <= gasRGB[15:8];
            Blue <= gasRGB[7:0];
		  end
		  else
		  begin
				Red <= back_RGB[23:16];
            Green <= back_RGB[15:8];
            Blue <= back_RGB[7:0];
		  end
        
	end
	
	else
	begin
	         Red <= 8'h00;
            Green <= 8'h00;
            Blue <= 8'h00;
	end
		  
		  
		  
    end 
    
	
endmodule
