`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/21/2014 04:55:13 AM
// Design Name: 
// Module Name: dflipflop_tb
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


module dflipflop_tb(

    );

	reg En;
	reg Clk;
	reg D;
	wire Q;

	dflipflop dff(En, Clk, D, Q);

    always #(3) Clk = ~Clk;


    initial begin
    	En = 1'b0;
    	Clk = 1'b0;
    	D = 1'b0;

    	#1 En = 1'b1;
    	#2 D = 1'b1;
    	#4 En = 1'b0;

    end


endmodule
