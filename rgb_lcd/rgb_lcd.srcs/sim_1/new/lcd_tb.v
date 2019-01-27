`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/22/2014 02:46:36 AM
// Design Name: 
// Module Name: lcd_tb
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


module lcd_tb(

    );
	reg clk;
	reg [15:0] sw;
	reg btnc;
	reg btnu;
	reg btnd;
	wire [15:0] led;
	wire [7:0] JA;

	always #(5) clk = ~clk;
	lcd display(clk, btnc, btnu, btnd, sw, led, JA);

	initial begin
		sw = 1'b0;
		clk = 1'b0;
		btnc = 1'b0;
		btnu = 1'b0;
		btnd = 1'b0;
		#80 btnc = 1'b1;
		#1 btnc = 1'b0;
	end
endmodule
