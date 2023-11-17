//-------------------------------------------------------------------------
//    spring.sv                                                            --
//    edited by JS and CC
//    used for ECE 385fFA22 final project
//-------------------------------------------------------------------------

module spring ( input Clk, Reset, frame_clk,
				    input [9:0] DrawX, DrawY,
				    input [9:0] BallX, BallY, BallS, Ball_y_step,
				    input [13:0][9:0] toolX, toolY, toolS,
			       output logic gain,
				    output [13:0] is_tool
				);
//output gain: if doodle should speed up.
//output is_tool: if current pixel belongs to spring.

	logic check;
	logic [13:0] sub_is_tool, sub_check;

	always_comb
	begin
		for (int i=0; i<14; i++)
		begin
			// sub check: check if doodle reaches one of springs.
			sub_check[i] =  (BallX + BallS) > (toolX[i] - toolS[i]) &&
							(BallX - BallS) < (toolX[i] + toolS[i]) &&
			 				(toolS[i] > 0)  &&  //why must bigger than 0?
							(BallY + BallS) > (toolY[i] - toolS[i]) &&
							(BallY + BallS) < (toolY[i] + toolS[i]) &&  // differnt from gyh  BallY - BallS
							(Ball_y_step <= 10'd20);  //why must less than 20?

			 // sub is_tool: check if current pixel belongs to one of springs.
			is_tool[i] = (DrawX <= (toolX[i] + toolS[i]))&&
							 (DrawX >= (toolX[i] - toolS[i]))&&
							 (DrawY <= (toolY[i] + toolS[i]))&&
							 (DrawY >= (toolY[i] - toolS[i]))&&
							 (toolS[i] > 0); //why must bigger than 0?
		end	

		if (sub_check != 14'b0)
			check = 1'b1;  // doodle reached spring, should gain speed.
		else
			check = 1'b0; 
		
		//if (sub_is_tool != 14'b0)
			//is_tool = 1'b1;  // this pixel belongs to spring
		//else
			//is_tool = 1'b0;

	end


	always_ff @ (posedge Reset or posedge frame_clk)
	begin
		if (Reset)
			gain <= 1'b0;
		else
			begin
				if (check)  // reach spring, gain power
					gain <= 1'b1;
				else
					gain <= 1'b0;
			end
		
	end



endmodule









