//-------------------------------------------------------------------------
//    score.sv                                                            --
//    edited by JS and CC
//    used for ECE 385fFA22 final project
//-------------------------------------------------------------------------
module score (input Clk, Reset,
			  input [10:0] score_num,
			  input logic [2:0] show,
			  input [9:0] DrawX, DrawY,
			  output logic is_score
			  );

////score positions on screen.
int score3_x_pos = 10'd190;
int score3_x_pos_dead = 10'd300;

int score3_y_pos = 10'd20;
int score3_y_pos_dead = 10'd300;

int score1_x_pos = 10'd210;
int score1_x_pos_dead = 10'd320;

int score1_y_pos = 10'd20;
int score1_y_pos_dead = 10'd300;

int score2_x_pos = 10'd230;
int score2_x_pos_dead = 10'd340;

int score2_y_pos = 10'd20;
int score2_y_pos_dead = 10'd300;

int score1_x_pos_used;
int score1_y_pos_used;
int score2_x_pos_used;
int score2_y_pos_used;
int score3_x_pos_used;
int score3_y_pos_used;

int text_w = 4'd8;   //width of single text
int text_h = 5'd16;  //height of single text

logic score;
int score1, score2, score3;
logic test;

always_comb
begin
	if (show == 3'd2) //dead, ending page
	begin
		score1_x_pos_used = score1_x_pos_dead;
		score1_y_pos_used = score1_y_pos_dead;
		score2_x_pos_used = score2_x_pos_dead;
		score2_y_pos_used = score2_y_pos_dead;
		score3_x_pos_used = score3_x_pos_dead;
		score3_y_pos_used = score3_y_pos_dead;
	end

	else if (show == 3'd0) //during playing
	begin
		score1_x_pos_used = score1_x_pos;
		score1_y_pos_used = score1_y_pos;
		score2_x_pos_used = score2_x_pos;
		score2_y_pos_used = score2_y_pos;
		score3_x_pos_used = score3_x_pos;
		score3_y_pos_used = score3_y_pos;
	end
	
	else
	begin
		score1_x_pos_used = score1_x_pos;
		score1_y_pos_used = score1_y_pos;
		score2_x_pos_used = score2_x_pos;
		score2_y_pos_used = score2_y_pos;
		score3_x_pos_used = score3_x_pos;
		score3_y_pos_used = score3_y_pos;
		
	end

	score3 = score_num/100;
	score1 = (score_num - 100*(score_num/100))/10; //two digits num
	score2 = score_num%10;

end

int diffx, diffy;
logic [10:0] font_addr;
logic [7:0] font_data;

always_comb
begin
	if (DrawX < (score1_x_pos_used + text_w)&&
		DrawX >= score1_x_pos_used          &&
		DrawY < (score1_y_pos_used + text_h)&&
		DrawY >= score1_y_pos_used
		)  // if pixel belongs to score1
	begin
		score = 1'b1;
		diffx = DrawX - score1_x_pos_used;
		diffy = DrawY - score1_y_pos_used;
		font_addr = diffy + text_h * score1;
	end

	else if (DrawX < (score2_x_pos_used + text_w)&&
			 DrawX >= score2_x_pos_used          &&
			 DrawY < (score2_y_pos_used + text_h)&&
			 DrawY >= score2_y_pos_used
			)  // if pixel belongs to score1
	begin
		score = 1'b1;
		diffx = DrawX - score2_x_pos_used;
		diffy = DrawY - score2_y_pos_used;
		font_addr = diffy + text_h * score2;
	end

	else if (DrawX < (score3_x_pos_used + text_w)&&
			 DrawX >= score3_x_pos_used          &&
			 DrawY < (score3_y_pos_used + text_h)&&
			 DrawY >= score3_y_pos_used
			)  // if pixel belongs to score1
	begin
		score = 1'b1;
		diffx = DrawX - score3_x_pos_used;
		diffy = DrawY - score3_y_pos_used;
		font_addr = diffy + text_h * score3;
	end

	else
	begin
		score = 1'b0;
		diffx = 0;
		diffy = 0;
		font_addr = 0;
	end
end

font_rom get_score (.addr(font_addr), .data(font_data));

always_comb
begin
	if (score && font_data [8-diffx])
		is_score = 1'b1;
	else
		is_score = 1'b0;
end

endmodule









