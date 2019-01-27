`timescale 1ns / 1ps

module tflipflop(
		input Clock,
		input Reset,	
		input En,
		output reg Q
	);
	wire xorTtoD;

	initial Q = 1'b0;

	xor 
		g(xorTtoD, Q, En);

	always @(negedge Reset, posedge Clock)
	begin
		// Reset occurs when low.
		if(!Reset)
			Q <= 0;
		else
			Q <= xorTtoD;
	end
endmodule