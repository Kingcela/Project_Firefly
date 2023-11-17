module  gas_status_rom
(

		input [11:0]  read_address,
		input  Clk,

		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] mem [0:4096];

initial
begin
	 $readmemh("Gas_status.txt", mem);
end

endmodule
