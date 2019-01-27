`timescale 1ns / 1ps



module encoder(
		input clk,
		input [15:0] sw, 
		input [7:0] JD,
		output [15:0] led,
		output [6:0] seg,
		output [7:0] an
    );
	wire reset = sw[15];
	wire dir1, trig1;
	wire [31:0] val1;
	controller control1(clk, reset, JD[7], JD[6], dir1, trig1);
	quadrature quad1(clk, reset, dir1, trig1, val1);

	assign led[7:0] = JD[7:0];

	displayDriver display(clk, val1, an, seg);
	

endmodule

module controller(
		input CLOCK, RESET,
		input pos, neg,
		output direction,
		output trigger
	);

	reg [2:0] posReg, negReg;
	assign direction = posReg[1] ^ negReg[2];
	assign trigger = posReg[2] ^ posReg[1] ^ negReg[2] ^ negReg[1];

	always @(posedge CLOCK) begin
			posReg <= {posReg[1:0], pos};
			negReg <= {negReg[1:0], neg};
	end

	initial begin
		posReg = 0;
		negReg = 0;
	end
endmodule



module quadrature(
		input CLOCK, RESET,
		input direction, trigger,
		output reg [31:0] value
	);
	
	always @(posedge trigger or posedge RESET) begin
		if (RESET) begin
			value = 0;
		end
		else if (trigger) begin
			value = direction ? value + 1 : value - 1;
		end
	end

	initial begin
		value = 0;
	end
	
endmodule
