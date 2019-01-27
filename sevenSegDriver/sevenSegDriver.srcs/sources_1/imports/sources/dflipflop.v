`timescale 1ns / 1ps


module dflipflop(
		input CLK,
		input RESET,
		input D,
		output reg Q
    );

	always @(posedge CLK or posedge RESET)
	begin
		if(RESET)
			Q <= 0;
		else 
			Q <= D;
	
	end



endmodule
