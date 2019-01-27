`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/21/2014 04:34:56 AM
// Design Name: 
// Module Name: oneBitAdder_tb
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


module oneBitAdder_tb(

    );

	reg A, B, Cin;
	wire S, Cout;
	oneBitAdder adder(A, B, Cin, S, Cout);

	initial begin
		A = 1'b0;
		B = 1'b0;
		Cin = 1'b0;

		#10 A = 1'b1;
		#20 B = 1'b1;
		#30 Cin = 1'b1;


	end

endmodule
