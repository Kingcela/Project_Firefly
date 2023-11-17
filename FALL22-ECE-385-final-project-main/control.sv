//-------------------------------------------------------------------------
//    control.sv  
//    including modules: control, start_page, end_page                                                         
//    edited by JS & CC
//    used for ECE 385fFA22 final project
//    edited 22/11/27
//    updated 22/11/29
//-------------------------------------------------------------------------

module control ( input logic Clk, Reset, frame_clk,
                 input logic [7:0] keycode,
					  input logic [7:0] keycode_ext,
					  input dead, drop,
					  output logic [2:0] show, // why 3 bit--change to 2 bit
					  output logic restart);
					  

	logic [6:0] delay, next_delay;					 
	enum logic [3:0]{start, play, dropping, death, halt} state, next_state;
	
	
	always_ff @ (posedge Reset or posedge frame_clk)
		begin
			if (Reset)
					state <= start;
			else
				state <= next_state;	
		end
		
	always_ff @ (posedge Reset or posedge frame_clk)
		begin
			if (Reset)
					delay <= 7'd0;
			else
					delay <= next_delay;
		end
	
	always_comb
		begin
			show = 3'd0;
			restart = 1'b0;
			next_delay = 7'd0;
			next_state = state;
			
         case(state)
			
			start:
			begin
				restart = 1'b1;
				show = 3'd1; //start page
				if (keycode == 8'd40 || keycode_ext == 8'd40) // press the ENTER
					next_state = play;
				//else
					//next_state = start; 
			end
			
			play:
			begin
				show = 3'd0; //play page
				if (dead)
					next_state = death;
				else if (drop)
					next_state = dropping;
				else 
					next_state = play;
			end
			
			dropping:
				begin
				next_delay = delay + 1;
				show = 3'd0;
				if (delay == 7'd50) //delay time
					begin
						next_state = death;
						next_delay = 0;
					end
				else
					next_state = dropping;
				end
					
			death:
			begin
				show = 3'd2; //game over page
				if (keycode == 8'd40 || keycode_ext == 8'd40) //press ENTER      
					next_state = halt;
				else
					next_state = death;
			end
								
			halt:
			begin
				show = 3'd1; //start page
				if (keycode == 8'd0 && keycode_ext == 8'd0) // why 0 here ???????
					next_state = start;
			end
				
			default: next_state = start;
			endcase
				
		end
		
		// show: 0: play, 1: start, 2: game over 		 
					 
endmodule


// start page module
// to import start button, title and name
// added 22/11/29
module start_page (input Clk, Reset, frame_clk,
                   input [9:0] DrawX, DrawY, 
						 output logic is_sb, is_st, is_sn,
                   output [9:0] SBX,SBY,STX,STY,SNX,SNY);
						 
logic [9:0] sbX, sbY, stX, stY, snX, snY;
parameter [9:0] sb_size = 10'd45;
parameter [9:0] st_size = 10'd201;
parameter [9:0] sn_size = 10'd79;
logic checksb, checkst, checksn;

always_ff @ (posedge Reset or posedge frame_clk ) // copy from doodler.sv
		begin 
			if (Reset)  // Asynchronous Rese	
				begin
					sbX <= 320;
					sbY <= 320;
					stX <= 320;
					stY <= 150;
					snX <= 320;
					snY <= 420;
				end
			else
				begin
				   sbX <= sbX;
					sbY <= sbY;
					stX <= stX;
					stY <= stY;
					snX <= snX;
					snY <= snY;
             end
		end

//////// check whether the pixel is OK ////////

// start button
	always_comb
		begin
			checksb = (DrawX <= (sbX + (sb_size-10'd1)/2) &&
						  DrawX >= (sbX - (sb_size-10'd1)/2) &&
						  DrawY <= (sbY + (sb_size-10'd1)/2) &&
						  DrawY >= (sbY - (sb_size-10'd1)/2)
						);
			if (checksb)
				is_sb = 1'b1;
			else
				is_sb = 1'b0;
					
		end

// start title		
	always_comb
		begin
			checkst = (DrawX <= (stX + (st_size-10'd1)/2) &&
						  DrawX >= (stX - (st_size-10'd1)/2) &&
						  DrawY <= (stY + (st_size-10'd1)/2) &&
						  DrawY >= (stY - (st_size-10'd1)/2)
						);
			if (checkst)
				is_st = 1'b1;
			else
				is_st = 1'b0;
					
		end

// start name		
	always_comb
		begin
			checksn = (DrawX <= (snX + (sn_size-10'd1)/2) &&
						  DrawX >= (snX - (sn_size-10'd1)/2) &&
						  DrawY <= (snY + (sn_size-10'd1)/2) &&
						  DrawY >= (snY - (sn_size-10'd1)/2)
						);
			if (checksn)
				is_sn = 1'b1;
			else
				is_sn = 1'b0;
					
		end

/////////// output ///////////
   assign SBX = sbX;
	assign SBY = sbY;		
   assign STX = stX;
	assign STY = stY;		
   assign SNX = snX;
	assign SNY = snY;			


endmodule


// end page module
// to import end doodler, restart button
// added 12/5
module end_page   (input Clk, Reset, frame_clk,
                   input [9:0] DrawX, DrawY, 
						 output logic is_ed, is_rb, is_ys,
                   output [9:0] EDX,EDY,RBX,RBY,YSX,YSY);
						 
logic [9:0] edX, edY, rbX, rbY, ysX, ysY;
parameter [9:0] ed_size = 10'd85;
parameter [9:0] rb_size = 10'd65;
parameter [9:0] ys_size = 10'd79;
 
logic checked, checkrb, checkys;

always_ff @ (posedge Reset or posedge frame_clk ) // copy from doodler.sv
		begin 
			if (Reset)  // Asynchronous Rese	
				begin
					edX <= 320;
					edY <= 100;
					rbX <= 320;
					rbY <= 400;
					ysX <= 320;
					ysY <= 240;
				end
			else
				begin
				   edX <= edX;
					edY <= edY;
					rbX <= rbX;
					rbY <= rbY;
					ysX <= ysX;
					ysY <= ysY;
             end
		end

//////// check whether the pixel is OK ////////

// end doodler
	always_comb
		begin
			checked = (DrawX <= (edX + (ed_size-10'd1)/2) &&
						  DrawX >= (edX - (ed_size-10'd1)/2) &&
						  DrawY <= (edY + (ed_size-10'd1)/2) &&
						  DrawY >= (edY - (ed_size-10'd1)/2)
						);
			if (checked)
				is_ed = 1'b1;
			else
				is_ed = 1'b0;
					
		end

// restart button		
	always_comb
		begin
			checkrb = (DrawX <= (rbX + (rb_size-10'd1)/2) &&
						  DrawX >= (rbX - (rb_size-10'd1)/2) &&
						  DrawY <= (rbY + (rb_size-10'd1)/2) &&
						  DrawY >= (rbY - (rb_size-10'd1)/2)
						);
			if (checkrb)
				is_rb = 1'b1;
			else
				is_rb = 1'b0;
					
		end

// your score	
	always_comb
		begin
			checkys = (DrawX <= (ysX + (ys_size-10'd1)/2) &&
						  DrawX >= (ysX - (ys_size-10'd1)/2) &&
						  DrawY <= (ysY + (ys_size-10'd1)/2) &&
						  DrawY >= (ysY - (ys_size-10'd1)/2)
						);
			if (checkys)
				is_ys = 1'b1;
			else
				is_ys = 1'b0;
					
		end


/////////// output ///////////
   assign EDX = edX;
	assign EDY = edY;		
   assign RBX = rbX;
	assign RBY = rbY;
   assign YSX = ysX;
	assign YSY = ysY;

endmodule









