`timescale 1ns / 1ps

module shiftRegister(
		input CLK,
		input [7:0] data, // new incoming bits to write in parallel
		input RW, // Read (shift bits out) is 0, Write (write data bits) is 1
		output out
    );

	reg [7:0] D;

	wire[7:0] bitQ;
	wire[7:0] bitD;
    assign bitQ[0] = 1'b0;

    genvar i;

    generate
        for(i = 0; i < 7; i = i+1)
            begin:bits
                dflipflop d(1'b1,CLK, bitD[i], bitQ[i+1]);
        end

        for(i = 0; i < 7; i = i+1)
            begin:bitSelects
                mux2to1 m(data[i],bitQ[i], RW, bitD[i]);
        end
    endgenerate


endmodule


module mux2to1(
	input b1,
	input b0,
	input S,
	output out
	);

	assign out = S ? b1 : b0;


endmodule