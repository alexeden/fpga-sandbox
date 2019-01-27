`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/27/2014 04:11:39 AM
// Design Name: 
// Module Name: tflipflop
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tflipflop(
    input CLOCK,
    input RESET,
    input T,
    output reg Q
    );

	


	always @(posedge CLOCK or posedge RESET)
	begin
		if(RESET)
			Q <= 0;
		else 
			Q <= Q ^ T;
	
	end

	initial begin
		Q = 0;
	end
endmodule
