/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */


// stair
// 40*10
// ['0xFFFFFF', '0x000000','0xFFF143']
module common_stair_RAM
(
		input [9:0] read_address,
		input Clk,
		output [1:0] data_out
);
// mem has width of 1 bits and a total of 400 addresses
logic [1:0] mem [0:399];

initial
begin
	 $readmemh("pic_txt/stair.txt", mem);
end


always_ff @ (posedge Clk) begin

	data_out<= mem[read_address];
	
end

endmodule



// left_doodler
// 35*35
// ['0x000000', '0xFFFFFF', '0xE8DD35', '0xFF0000']
module left_doodler_RAM
(
		input [10:0] read_address,
		input Clk,
		output [1:0] data_out
);
// mem has width of 1 bits and a total of 400 addresses
logic [1:0] mem [0:1224];

initial
begin
	 $readmemh("pic_txt/left_doodler.txt", mem);
end


always_ff @ (posedge Clk) begin

	data_out<= mem[read_address];
	
end

endmodule


// right_doodler
// 35*35
// ['0x000000', '0xFFFFFF', '0xE8DD35', '0xFF0000']
module right_doodler_RAM
(
		input [10:0] read_address,
		input Clk,
		output [1:0] data_out
);
// mem has width of 1 bits and a total of 400 addresses
logic [1:0] mem [0:1224];

initial
begin
	 $readmemh("pic_txt/right_doodler.txt", mem);
end


always_ff @ (posedge Clk) begin

	data_out<= mem[read_address];
	
end

endmodule



// shooting_doodler
// 35*39
// ['0x000000', '0xFFFFFF', '0xE8DD35', '0xFF0000']
module shooting_doodler_RAM
(
		input [10:0] read_address,
		input Clk,
		output [1:0] data_out
);
// mem has width of 1 bits and a total of 400 addresses
logic [1:0] mem [0:1364];

initial
begin
	 $readmemh("pic_txt/shooting_doodler.txt", mem);
end


always_ff @ (posedge Clk) begin

	data_out<= mem[read_address];
	
end

endmodule


// left_monster
// 39*39
// ['0x000000', '0xF0E5DD', '0xD1A167', '0x30955E', '0xF8AD1E', '0xB11E31', '0x65C8D3'] 
// BLK, WHITE, EYE, GREEN, YELLOW, RED, BG
module left_monster_RAM
(
		input [10:0] read_address,
		input Clk,
		output [2:0] data_out
);
// mem has width of 1 bits and a total of 400 addresses
logic [2:0] mem [0:1520];

initial
begin
	 $readmemh("pic_txt/left_monster.txt", mem);
end


always_ff @ (posedge Clk) begin

	data_out<= mem[read_address];
	
end

endmodule


// right_monster
// 39*39
// ['0x000000', '0xF0E5DD', '0xD1A167', '0x30955E', '0xF8AD1E', '0xB11E31', '0x65C8D3'] 
// BLK, WHITE, EYE, GREEN, YELLOW, RED, BG
module right_monster_RAM
(
		input [10:0] read_address,
		input Clk,
		output [2:0] data_out
);
// mem has width of 1 bits and a total of 400 addresses
logic [2:0] mem [0:1520];

initial
begin
	 $readmemh("pic_txt/right_monster.txt", mem);
end


always_ff @ (posedge Clk) begin

	data_out<= mem[read_address];
	
end

endmodule


// start_button
// 45*45
// ['0x000000', '0x66D336', '0xF3F272', '0xFF0000'] 
// BLK, GREEN, YELLOW, RED
module start_button_RAM
(
		input [10:0] read_address,
		input Clk,
		output [1:0] data_out
);
// mem has width of 1 bits and a total of 400 addresses
logic [1:0] mem [0:2024];

initial
begin
	 $readmemh("pic_txt/start_button.txt", mem);
end


always_ff @ (posedge Clk) begin

	data_out<= mem[read_address];
	
end

endmodule

// start_title
// 201*201
// ['0xA00000', '0x06A000'] # RED, GREEN
module start_title_RAM
(
		input [15:0] read_address,
		input Clk,
		output logic data_out
);
// mem has width of 1 bits and a total of 400 addresses
logic mem [0:40400];

initial
begin
	 $readmemh("pic_txt/start_title.txt", mem);
end


always_ff @ (posedge Clk) begin

	data_out<= mem[read_address];
	
end

endmodule

// start_name
// 79*79
// ['0x000000', '0xFF0000'] # BLK, RED
module start_name_RAM
(
		input [12:0] read_address,
		input Clk,
		output logic data_out
);
// mem has width of 1 bits and a total of 400 addresses
logic mem [0:6240];

initial
begin
	 $readmemh("pic_txt/start_name.txt", mem);
end


always_ff @ (posedge Clk) begin

	data_out<= mem[read_address];
	
end

endmodule

// spring
// 15*15
// ['0x000000', '0xFF0000'] # BLK, RED
module spring_RAM
(
		input [7:0] read_address,
		input Clk,
		output logic data_out
);
// mem has width of 1 bits and a total of 400 addresses
logic mem [0:224];

initial
begin
	 $readmemh("pic_txt/spring.txt", mem);
end


always_ff @ (posedge Clk) begin

	data_out<= mem[read_address];
	
end

endmodule


// bullet
// 7*7
// ['0x000000', '0xFFDA7F', '0xFF0000'] # BLK, BULLET, RED
module bullet_RAM
(
		input [5:0] read_address,
		input Clk,
		output [1:0] data_out
);
// mem has width of 1 bits and a total of 400 addresses
logic [1:0] mem [0:48];

initial
begin
	 $readmemh("pic_txt/bullet.txt", mem);
end


always_ff @ (posedge Clk) begin

	data_out<= mem[read_address];
	
end

endmodule


// ending page
// added 12/5

// end_doodler
// 85*85
// ['0x000000', '0xFFFFFF', '0xE8DD35', '0x166138', '0xB11E31', '0x35DCE8'] 
// BLK, WHITE, DOODLER, GREEN, RED, BG
module end_doodler_RAM
(
		input [12:0] read_address,
		input Clk,
		output [2:0] data_out
);
// mem has width of 1 bits and a total of 400 addresses
logic [2:0] mem [0:7224];

initial
begin
	 $readmemh("pic_txt/end_doodler.txt", mem);
end


always_ff @ (posedge Clk) begin

	data_out<= mem[read_address];
	
end

endmodule


// restart_button
// 65*65
// ['0x000000', '0x66D336', '0xF3F272', '0xFF0000'] 
// BLK, GREEN, YELLOW, RED
module restart_button_RAM
(
		input [12:0] read_address,
		input Clk,
		output [1:0] data_out
);
// mem has width of 1 bits and a total of 400 addresses
logic [1:0] mem [0:4224];

initial
begin
	 $readmemh("pic_txt/restart_button.txt", mem);
end


always_ff @ (posedge Clk) begin

	data_out<= mem[read_address];
	
end

endmodule


// your_score
// 79*79
//  ['0x000000', '0xFF0000']
module your_score_RAM
(
      input [12:0] read_address,
		input Clk,
		output data_out
);
// mem has width of 1 bits and a total of 400 addresses
logic mem [0:6240];

initial
begin
	 $readmemh("pic_txt/your_score.txt", mem);
end


always_ff @ (posedge Clk) begin

	data_out<= mem[read_address];
	
end

endmodule


























