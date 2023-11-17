//-------------------------------------------------------------------------
//    collision.sv series                                                            
//    edited by JS
//    used for ECE 385fFA22 final project
//    2022/11/25
//-------------------------------------------------------------------------


// monster_stair.sv
// check doodler-stair collision	
module doodler_stair ( input Clk, Reset, frame_clk,
						 input [9:0] BallX, BallY, BallS, Ball_y_step,
						 input [13:0][9:0] StairX, StairY, 
						 input [9:0] StairS,
						 output logic collision
                  );
	
	logic [13:0] check;

	always_comb
		begin
			for (int i = 0; i<14; i++)
				begin
					check[i] = ((Ball_y_step < 10'd50) &&
							      ((BallX + BallS) >= (StairX[i] + (~StairS+10'd1))) &&
							      ((BallX - BallS) <= (StairX[i] + StairS)) &&
							      ((BallY + BallS + Ball_y_step) >= (StairY[i] - 10'd5)) &&
							      ((BallY + BallS + Ball_y_step) <= (StairY[i] + 10'd5))
							      );						  
				end
		end
	
	always_ff @ (posedge Reset or posedge frame_clk ) // copy from doodler.sv
		begin 
			if (Reset)  // Asynchronous Rese
				collision <= 1'b0;
			else
				begin
					if (check[0] || check [1] || check[2] || check [3] ||
					    check[4] || check [5] || check[6] || check [7] ||
						 check[8] || check [9] || check[10] || check [11] || 
						 check[12] || check [13])
						begin
							collision <= 1'b1;
						end
					else
							collision <= 1'b0;
				end
		end
		
endmodule
	
	


// doodler_monster.sv	
// check whether doodler touches monster or beats monster

module doodler_monster ( input Clk, Reset, frame_clk,
						 input [9:0] BallX, BallY, BallS, Ball_y_step,
						 input [9:0] MonsterX, MonsterY, MonsterS, 
						 input logic appear,
						 output logic dead,
						 output logic beat_monster
                  );
						
	logic check, beat;
	
	always_comb
		begin
			check = (((BallX + BallS) > (MonsterX)) &&
						((BallX - BallS) < (MonsterX + 10'd39)) &&
						((BallY + BallS) > (MonsterY)) &&
						((BallY - BallS) < (MonsterY + 10'd39)) && appear);
			beat = (check && (Ball_y_step < 10'd100)); // why 100 here ??? MEANS NOT FALLING???
		end
	
	always_ff @ (posedge Reset or posedge frame_clk ) // copy from doodler.sv
		begin 
			if (Reset)  // Asynchronous Rese
				begin
					dead <= 1'b0;
					beat_monster <= 1'b0; 
				end
			else	
				begin
					if (check && (~beat))
						dead <= 1'b1;
					else if (beat) // change from beat to check
						beat_monster <= 1'b1;
					else 
					begin
						dead <= 1'b0;
						beat_monster <= 1'b0;
					end
				end
			end
	
endmodule


// bullet_monster.sv	
// check whether nullet hits the monster
module bullet_monster ( input Clk, Reset, frame_clk,
						 input [9:0] BulletX, BulletY, BulletS,
						 input [9:0] MonsterX, MonsterY, MonsterS, 
						 input logic appear, fly, //what is fly ???
						 output logic hit
                  );
						
	logic check;
	
	always_comb
		begin
			check = (((BulletX + BulletS) > (MonsterX)) &&
						((BulletX - BulletS) < (MonsterX + 10'd39)) &&
						((BulletY + BulletS) > (MonsterY)) &&
						((BulletY - BulletS) < (MonsterY + 10'd39)) && appear && fly);
	
		end
	
	always_ff @ (posedge Reset or posedge frame_clk ) // copy from doodler.sv
		begin 
			if (Reset)  // Asynchronous Rese
				hit <= 1'b0;
			else
				begin
					if (check)
						hit <= 1'b1;
					else 
						hit <= 1'b0;
				end
		end
	
						
endmodule















