`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/22/2014 02:59:46 AM
// Design Name: 
// Module Name: encoder_tb
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


module encoder_tb(

    );
	reg clk;
	reg [15:0] sw;
	wire [15:0] led;
	wire [6:0] seg;
	wire [7:0] an;
	wire [7:0] JD;

	reg pos1, neg1;
	wire dir1, trig1;
	reg reset;
	wire [31:0] val1;

	always #(5) clk = ~clk;

	controller control1(clk, reset, pos1, neg1, dir1, trig1);
	quadrature quad1(clk, reset, dir1, trig1, val1);

	initial begin
		clk = 1'b0;
		pos1 = 0;
		neg1 = 0;
		reset = 0;

		#100 pos1 = 1;
		#25 neg1 = 1;
		#50 pos1 = 0;
		#25 neg1 = 0;

		#100

		#100 neg1 = 1;
		#25 pos1 = 1;
		#50 neg1 = 0;
		#25 pos1 = 0;
	end
endmodule
