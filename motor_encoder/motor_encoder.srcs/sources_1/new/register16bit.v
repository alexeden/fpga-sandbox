`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/27/2014 10:18:34 AM
// Design Name: 
// Module Name: register16bit
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


module register16bit(
    input CLOCK,
    input RESET,
    input [15:0] D,
    output reg [15:0] Q
    );
	
	always @(posedge CLOCK or posedge RESET) begin
		if (RESET) begin
			Q <= 0;
			
		end
		else begin
			Q <= D;
		end
	end

endmodule
