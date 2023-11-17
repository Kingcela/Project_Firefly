//-------------------------------------------------------------------------
//                                                                       --
//                                                                       --
//      For use with ECE 385 Lab 62                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------

module lab62 (

      ///////// Clocks /////////
      input     MAX10_CLK1_50, 

      ///////// KEY /////////
      input    [ 1: 0]   KEY,

      ///////// SW /////////
      input    [ 9: 0]   SW,

      ///////// LEDR /////////
      output   [ 9: 0]   LEDR,

      ///////// HEX /////////
      output   [ 7: 0]   HEX0,
      output   [ 7: 0]   HEX1,
      output   [ 7: 0]   HEX2,
      output   [ 7: 0]   HEX3,
      output   [ 7: 0]   HEX4,
      output   [ 7: 0]   HEX5,

      ///////// SDRAM /////////
      output             DRAM_CLK,
      output             DRAM_CKE,
      output   [12: 0]   DRAM_ADDR,
      output   [ 1: 0]   DRAM_BA,
      inout    [15: 0]   DRAM_DQ,
      output             DRAM_LDQM,
      output             DRAM_UDQM,
      output             DRAM_CS_N,
      output             DRAM_WE_N,
      output             DRAM_CAS_N,
      output             DRAM_RAS_N,

      ///////// VGA /////////
      output             VGA_HS,
      output             VGA_VS,
      output   [ 3: 0]   VGA_R,
      output   [ 3: 0]   VGA_G,
      output   [ 3: 0]   VGA_B,


      ///////// ARDUINO /////////
      inout    [15: 0]   ARDUINO_IO,
      inout              ARDUINO_RESET_N 

);




logic Reset_h, vssig, blank, sync, VGA_Clk;

//=======================================================
//  REG/WIRE declarations
//=======================================================
	logic SPI0_CS_N, SPI0_SCLK, SPI0_MISO, SPI0_MOSI, USB_GPX, USB_IRQ, USB_RST;
	logic [3:0] hex_num_4, hex_num_3, hex_num_1, hex_num_0; //4 bit input hex digits
	logic [1:0] signs;
	logic [1:0] hundreds;
	logic [9:0] drawxsig, drawysig, ballxsig, ballysig, ballsizesig;
	logic [7:0] Red, Blue, Green;
	logic [7:0] keycode; // 
	logic [7:0] keycode_ext; //added to extend keycode nums
	logic [13:0][9:0] stairxsig, stairysig;
	logic [9:0] monsterxsig, monsterysig, monstersizesig; // added 22/11/24
	logic [13:0][9:0] toolxsig, toolysig, toolsizesig;
	logic [9:0] bulletxsig, bulletysig, bulletsizesig; //added 12/1
	logic [9:0] sbxsig, sbysig, stxsig, stysig, snxsig, snysig; // added 11/29
	logic [9:0] edxsig, edysig, rbxsig, rbysig, ysxsig, ysysig; //added 12/5
	
//=======================================================
//  Component declarations
//=======================================================

// stair
	logic [13:0] find;
	logic [9:0]  stair_size;
	logic [13:0] tool_signal;
	logic [13:0] move_message, active_message;
	
// doodler
	logic [1:0] doodler_state;
	logic [2:0] is_doodler;
	logic [9:0] ballystep;
	logic [9:0] distance; //added 12/3
	logic drop;
	
// monster
// added 11/24
	logic monster_state;
	logic is_monster;
	logic [1:0] turn;

	
// spring
// added 11/29
	logic gain;
	logic [13:0] is_tool; //is_spring
	
// bullet
// added 12/01
   logic is_bullet;
	logic fly;

	
// collision
// added 11/27
	logic collision;
	logic hit, beat_monster, appear;
	logic dead;
	
// total_distance
	logic [31:0] distance_sum;
	
// control
   logic [2:0] show;
	logic restart;
	
// start page
// added 11/29
   logic is_sb, is_st, is_sn;
	
// end page
// added 12/5
	logic is_ed, is_rb, is_ys;
	
// score
// added 12/5
	logic is_score;
	




//=======================================================
//  Structural coding
//=======================================================
	assign ARDUINO_IO[10] = SPI0_CS_N;
	assign ARDUINO_IO[13] = SPI0_SCLK;
	assign ARDUINO_IO[11] = SPI0_MOSI;
	assign ARDUINO_IO[12] = 1'bZ;
	assign SPI0_MISO = ARDUINO_IO[12];
	
	assign ARDUINO_IO[9] = 1'bZ; 
	assign USB_IRQ = ARDUINO_IO[9];
		
	//Assignments specific to Circuits At Home UHS_20
	assign ARDUINO_RESET_N = USB_RST;
	assign ARDUINO_IO[7] = USB_RST;//USB reset 
	assign ARDUINO_IO[8] = 1'bZ; //this is GPX (set to input)
	assign USB_GPX = 1'b0;//GPX is not needed for standard USB host - set to 0 to prevent interrupt
	
	//Assign uSD CS to '1' to prevent uSD card from interfering with USB Host (if uSD card is plugged in)
	assign ARDUINO_IO[6] = 1'b1;
	
	//HEX drivers to convert numbers to HEX output
	HexDriver hex_driver4 (hex_num_4, HEX4[6:0]);
	assign HEX4[7] = 1'b1;
	
	HexDriver hex_driver3 (hex_num_3, HEX3[6:0]);
	assign HEX3[7] = 1'b1;
	
	HexDriver hex_driver1 (hex_num_1, HEX1[6:0]);
	assign HEX1[7] = 1'b1;
	
	HexDriver hex_driver0 (hex_num_0, HEX0[6:0]);
	assign HEX0[7] = 1'b1;
	
	//fill in the hundreds digit as well as the negative sign
	assign HEX5 = {1'b1, ~signs[1], 3'b111, ~hundreds[1], ~hundreds[1], 1'b1};
	assign HEX2 = {1'b1, ~signs[0], 3'b111, ~hundreds[0], ~hundreds[0], 1'b1};
	
	
	//Assign one button to reset
	assign {Reset_h}=~ (KEY[0]);

	//Our A/D converter is only 12 bit
	assign VGA_R = Red[7:4];
	assign VGA_B = Blue[7:4];
	assign VGA_G = Green[7:4];
	
	
	lab62soc u0 (
		.clk_clk                           (MAX10_CLK1_50),  //clk.clk
		.reset_reset_n                     (1'b1),           //reset.reset_n
		.altpll_0_locked_conduit_export    (),               //altpll_0_locked_conduit.export
		.altpll_0_phasedone_conduit_export (),               //altpll_0_phasedone_conduit.export
		.altpll_0_areset_conduit_export    (),               //altpll_0_areset_conduit.export
		.key_external_connection_export    (KEY),            //key_external_connection.export

		//SDRAM
		.sdram_clk_clk(DRAM_CLK),                            //clk_sdram.clk
		.sdram_wire_addr(DRAM_ADDR),                         //sdram_wire.addr
		.sdram_wire_ba(DRAM_BA),                             //.ba
		.sdram_wire_cas_n(DRAM_CAS_N),                       //.cas_n
		.sdram_wire_cke(DRAM_CKE),                           //.cke
		.sdram_wire_cs_n(DRAM_CS_N),                         //.cs_n
		.sdram_wire_dq(DRAM_DQ),                             //.dq
		.sdram_wire_dqm({DRAM_UDQM,DRAM_LDQM}),              //.dqm
		.sdram_wire_ras_n(DRAM_RAS_N),                       //.ras_n
		.sdram_wire_we_n(DRAM_WE_N),                         //.we_n

		//USB SPI	
		.spi0_SS_n(SPI0_CS_N),
		.spi0_MOSI(SPI0_MOSI),
		.spi0_MISO(SPI0_MISO),
		.spi0_SCLK(SPI0_SCLK),
		
		//USB GPIO
		.usb_rst_export(USB_RST),
		.usb_irq_export(USB_IRQ),
		.usb_gpx_export(USB_GPX),
		
		//LEDs and HEX
		.hex_digits_export({hex_num_4, hex_num_3, hex_num_1, hex_num_0}),
		.leds_export({hundreds, signs, LEDR}),
		.keycode_export(keycode),
		.keycode_ext_export(keycode_ext)
		
	 );


//instantiate a vga_controller, ball, and color_mapper here with the ports.
	vga_controller vga0 (
			.*,
			.Clk				(MAX10_CLK1_50),
			.Reset			(Reset_h),
			.hs				(VGA_HS),
			.vs				(VGA_VS),
			.pixel_clk		(VGA_CLK),
			.DrawX			(drawxsig),
			.DrawY			(drawysig)
		);
		
	/*
	ball ball0 (
		.Reset			(Reset_h),
		.frame_clk		(VGA_VS),
		.keycode			(keycode),
		.BallX			(ballxsig),
		.BallY			(ballysig),
		.BallS			(ballsizesig)
		);
	*/
	
	doodler_state state0 (
		.Reset         (Reset_h | restart),
		.frame_clk     (VGA_VS),
		.keycode       (keycode),
		.keycode_ext   (keycode_ext),
		.state         (doodler_state)
	);
	
	doodler doodler0 (
		.Reset			(Reset_h | restart),
		.frame_clk		(VGA_VS),
		.keycode			(keycode),
		.keycode_ext   (keycode_ext),
		.DrawX			(drawxsig),
		.DrawY			(drawysig),
		.doodler_state (doodler_state),
		.is_doodler    (is_doodler),
		.BallX			(ballxsig),
		.BallY			(ballysig),
		.BallS			(ballsizesig),
		.Ball_Y_Step_out (ballystep),
		.collision     (collision),
		.gain          (gain),
		.drop          (drop),
		.distance      (distance),
		.distance_sum  (distance_sum)
		);
		
	//	monster and monster_state
	// added 22/11/24
	monster_state state1 (
		.Reset         (Reset_h | restart),
		.frame_clk     (VGA_VS),
		.turn          (turn),
		.state         (monster_state)
	   );
	 

	monster monster0 (
		.Clk           (MAX10_CLK1_50),
		.Reset			(Reset_h | restart), 
		.frame_clk		(VGA_VS),
		.gene          (1'b1),
		.hit           (hit),
		.beat_monster  (beat_monster),
		.DrawX			(drawxsig),
		.DrawY			(drawysig),
		.monster_state (monster_state),
		.distance      (distance),
		.is_monster    (is_monster),
		.Monster_X		(monsterxsig),
		.Monster_Y		(monsterysig),
		.Monster_S		(monstersizesig),
		.turn          (turn),
		.appear        (appear)
	   );	
	
	stair stair0 (
		.Reset			(Reset_h | restart),
		.Clk				(MAX10_CLK1_50),
		.frame_clk     (VGA_VS),
		.DrawX			(drawxsig),
		.DrawY			(drawysig),
		.Stair_X       (stairxsig),
		.Stair_Y       (stairysig),
		.find          (find),
		.stair_size    (stair_size),
		.tool_signal   (14'b00100000010000),
		.toolX         (toolxsig),
		.toolY         (toolysig),
		.toolS         (toolsizesig),
		.move_message  (14'b00000001010001),
		.active_message(14'b10110101110101),
		.distance      (distance)
		);

	spring spring0 (
	   .Reset			(Reset_h | restart),
		.frame_clk		(VGA_VS),
		.Clk				(MAX10_CLK1_50),
		.DrawX			(drawxsig),
		.DrawY			(drawysig),
		.BallX			(ballxsig),
		.BallY			(ballysig),
		.BallS			(ballsizesig),
		.Ball_y_step   (ballystep),
		.toolX         (toolxsig),
		.toolY         (toolysig),
		.toolS         (toolsizesig),
		.gain          (gain),
		.is_tool       (is_tool)		
	   );  
		
	bullet bullet0   (
	   .Reset			(Reset_h | restart),
		.frame_clk		(VGA_VS),
		.Clk           (MAX10_CLK1_50),
		.DrawX			(drawxsig),
		.DrawY			(drawysig),
		.keycode       (keycode),
		.keycode_ext   (keycode_ext),
		.bullet_x      (ballxsig),
		.bullet_y      (ballysig),
		.bullet_s      (ballsizesig),
		.fly           (fly),
		.is_bullet     (is_bullet),
		.BulletX		   (bulletxsig),
		.BulletY			(bulletysig),
		.BulletS			(bulletsizesig)
	   );
	
	color_mapper cm0 (
		.Clk           (MAX10_CLK1_50),
		//.Reset         (Reset_h)// || restart), // Reset and frame_clk added 11/29
		//.frame_clk     (VGA_VS),
		.BallX			(ballxsig),
		.BallY			(ballysig),
		.DrawX			(drawxsig),
		.DrawY			(drawysig),
		.Ball_size		(ballsizesig),
		.Stair_X       (stairxsig),
		.Stair_Y       (stairysig),
		.MonsterX      (monsterxsig),
		.MonsterY      (monsterysig),
		.toolX         (toolxsig),
		.toolY         (toolysig),
		.toolS         (toolsizesig),
		.BulletX       (bulletxsig),
		.BulletY       (bulletysig),
		.BulletS       (bulletsizesig),
		.SBX           (sbxsig),
		.SBY           (sbysig),
		.STX           (stxsig),
		.STY           (stysig),
		.SNX           (snxsig),
		.SNY           (snysig),
		.EDX           (edxsig),
		.EDY           (edysig),
		.RBX           (rbxsig),
		.RBY           (rbysig),
		.YSX           (ysxsig),
		.YSY           (ysysig),
		.find          (find),
		.is_doodler    (is_doodler),
		.is_monster    (is_monster),
	   .is_tool       (is_tool),
	   .is_bullet     (is_bullet),	
		.is_sb         (is_sb),
		.is_st         (is_st),
		.is_sn         (is_sn),
		.is_ed         (is_ed),
		.is_rb         (is_rb),
		.is_ys         (is_ys),
		.is_score      (is_score),
		.doodler_state (doodler_state),
		.monster_state (monster_state),
		.appear        (appear),
		.show          (show),
		.keycode       (keycode),
		.keycode_ext   (keycode_ext),
		.Red           (Red),
		.Green         (Green),
		.Blue          (Blue)
		);

		
   // collision 
   // added 11/27	
	doodler_stair ds0 (
	   .Clk           (MAX10_CLK1_50),
		.Reset			(Reset_h | restart),
		.frame_clk		(VGA_VS),
		.StairX        (stairxsig),
		.StairY        (stairysig),
		.StairS        (stair_size),
		.BallX         (ballxsig),
		.BallY         (ballysig),
		.BallS         (ballsizesig),
		.Ball_y_step   (ballystep),
	   .collision     (collision)
		);
		
	doodler_monster dm0 (
	   .Clk           (MAX10_CLK1_50),
		.Reset			(Reset_h | restart),
		.frame_clk		(VGA_VS),
		.BallX         (ballxsig),
		.BallY         (ballysig),
		.BallS         (ballsizesig),
		.Ball_y_step   (ballystep),
		.MonsterX		(monsterxsig),
		.MonsterY		(monsterysig),
		.MonsterS		(monstersizesig),
		.appear        (appear),
		.dead          (dead),
		.beat_monster  (beat_monster)
		);
	
	bullet_monster bm0 (
		.Clk           (MAX10_CLK1_50),
		.Reset			(Reset_h | restart),
		.frame_clk		(VGA_VS),
		.BulletX       (bulletxsig),
		.BulletY       (bulletysig),
		.BulletS       (bulletsizesig),
		.MonsterX		(monsterxsig),
		.MonsterY		(monsterysig),
		.MonsterS		(monstersizesig),
		.appear        (appear),
		.fly           (fly),
		.hit           (hit)
	   );
		
		
    // control
	 // added 12/4
	 
	 control controller(
	   .Clk           (MAX10_CLK1_50),
		.Reset			(Reset_h),
		.frame_clk		(VGA_VS),
		.dead          (dead), 
		.keycode       (keycode),
		.keycode_ext   (keycode_ext),
		.drop          (drop), 
		.show          (show), 
	   .restart       (restart)
	   );
	 

	 
	 // total_distance
	 // added 12/4

	 total_distance tot_dis0(
		.Reset			(Reset_h | restart),
		.frame_clk		(VGA_VS),
		.drop          (drop),
		.distance      (distance),
		.distance_sum  (distance_sum)   
	   );
	 
	 
	 
    // start_page
	 // added 11/29
	 
	 start_page start0(
	   .Clk           (MAX10_CLK1_50),
		.Reset			(Reset_h | restart),
		.frame_clk		(VGA_VS),
		.DrawX         (drawxsig), 
		.DrawY         (drawysig),
		.is_sb         (is_sb), 
		.is_st         (is_st), 
	   .is_sn         (is_sn),
		.SBX           (sbxsig), 
		.SBY           (sbysig),
		.STX           (stxsig), 
		.STY           (stysig),
		.SNX           (snxsig), 
		.SNY           (snysig)
	   );
	 

	 
	 // end_page
	 // added 11/29
	 
	 end_page end0(
	   .Clk           (MAX10_CLK1_50),
		.Reset			(Reset_h | restart),
		.frame_clk		(VGA_VS),
		.DrawX         (drawxsig), 
		.DrawY         (drawysig),
		.is_ed         (is_ed), 
		.is_rb         (is_rb), 
		.is_ys         (is_ys),
		.EDX           (edxsig), 
		.EDY           (edysig),
		.RBX           (rbxsig), 
		.RBY           (rbysig),
		.YSX           (ysxsig),
		.YSY           (ysysig)
	 );
	 
	 // score
	 // added 12/5
	 logic [10:0] score_num;
	 assign score_num = distance_sum/500;

	 score score0(
	   .Clk           (MAX10_CLK1_50),
		.Reset			(Reset_h | restart),
		.score_num     (score_num),
		.show          (show),
		.DrawX         (drawxsig), 
		.DrawY         (drawysig),
		.is_score      (is_score)
	   );
	 
	
		
endmodule
























