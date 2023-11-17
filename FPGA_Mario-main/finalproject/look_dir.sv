module look_dir (input  logic Clk, 
					input logic [1:0] Add_En,
              output logic  count);
    always_ff @ (posedge Clk)
    begin
	 if((Add_En == 0)||(Add_En ==1))
			count <= Add_En;
		
    end
	
endmodule