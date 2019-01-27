`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/26/2014 01:00:27 AM
// Design Name: 
// Module Name: neopixels_tb
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


module neopixels_tb(
    );

	reg clk = 1'b1;
	reg [15:0] sw = 0;
	wire [15:0] led;
	wire data;
	always #(5) clk = ~clk;

	neopixels neo(clk, sw, led, data);


	initial begin
		sw[0] = 0;
		#4000 sw[0] = 1;
		#2500 sw[0] = 0;
		#1500 sw[0] = 1;
	end



endmodule
