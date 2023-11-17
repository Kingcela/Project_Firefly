//-------------------------------------------------------------------------
//    bullet.sv                                                            
//    based on the ball.sv provided in lab6
//    edited by JS
//    used for ECE 385FA22 final project
//    2022/11/25
//-------------------------------------------------------------------------

module bullet ( input Reset, frame_clk, Clk,
					 //input hit,
					 //input [1:0] direction,
					 input [9:0] DrawX, DrawY,
					 input [7:0] keycode, keycode_ext,
					 input [9:0] bullet_x, bullet_y, bullet_s, // use doodler addr
					 output logic fly, 
					 output logic is_bullet,
                output [9:0]  BulletX, BulletY, BulletS );
					 
/////////////// local vals ////////////////				
   parameter [9:0] x_min = 10'd170;  // left edge 
	parameter [9:0] x_max = 10'd469;  // right edge
	
	logic check;
	logic bullet_size = 10'd2;
	assign BulletS = bullet_size;
	logic [9:0] speedx, speedy; ////changed
	
	logic frame_clk_delayed, frame_clk_rising_edge;
	logic shoot_clk_delayed, shoot_clk_rising_edge;
	logic [4:0] delayed_clk;
	
	//added 12/1
	logic [1:0] direction;
	logic shoot;
	
/////////////// adjusted clk ///////////////
   always_ff @ (posedge Reset or posedge frame_clk)		
///////////// movement of bullet /////////////
		begin
			if (Reset)
			begin
				speedx <= 10'd0;
				speedy <= 10'd0;
			end
			else
				begin
				case(direction)
				2'd0: // shoot up
				begin
					speedx <= 10'd0;
					speedy <= ~10'd10+1'b1;
				end
				2'd1: // shoot left
				begin
					speedx <= ~10'd4 +1'b1;
					speedy <= ~10'd10 +1'b1;
				end
				2'd2: // shoot right
				begin
					speedx <= 10'd4 ;
					speedy <= ~10'd10+1'b1;
				end
				default: 
				begin
					speedx <= speedx;
					speedy <= speedy;
				end
				endcase
				end
		
		end
		
	
// control the direction of shooting bullet
// 79:right, 80:left, 82:up
	always_ff @ (posedge Clk)
		begin
			if ((keycode[7:0] == 8'd82) || (keycode_ext[7:0] == 8'd82))
				begin
					shoot <= 1'd1;
					direction <= 2'd0; //up
				end
			else if ((keycode[7:0] == 8'd79) || (keycode_ext[7:0] == 8'd79))
				begin
					shoot <= 1'd1;
					direction <= 2'd2; //right
				end
		   else if ((keycode[7:0] == 8'd80) || (keycode_ext[7:0] == 8'd80))
				begin
					shoot <= 1'd1;
					direction <= 2'd1; //left
				end
			else
				begin
				    shoot <= 1'd0;
					 direction <= 2'd0; //up
				end
		end
	
//////
logic beginning;
// generate a bullet above the doodler
	always_ff @ (posedge Reset or posedge frame_clk)
		begin
			if (Reset)
			begin
					fly <= 1'b0;
					beginning <= 1'b0;
			end
			
			else
			begin   if(shoot)
					  beginning <= 1;
					
					if(beginning)
					begin
				    if (fly == 1'b0)
					begin
						fly <= fly + 10'd1;
						BulletX <= bullet_x;
						BulletY <= bullet_y - bullet_s;
					end

					else 
					begin
						BulletX <= BulletX + speedx;
						BulletY <= BulletY + speedy;
						if(BulletX >= x_max || BulletX <= x_min || BulletY <= 10'd0)
						beginning <= 0;	
					end
					end

			end




			
		end


// check if is bullet
	always_comb
		begin
			check = (DrawX <= (BulletX + bullet_size ) &&
						DrawX >= (BulletX + ~bullet_size + 10'b1) &&
						DrawY <= (BulletY + bullet_size) &&
						DrawY >= (BulletY + ~bullet_size + 10'b1)
						);
			if (check & fly)
				is_bullet = 1'b1;
			else
				is_bullet = 1'b0;
					
		end




	
					
endmodule







