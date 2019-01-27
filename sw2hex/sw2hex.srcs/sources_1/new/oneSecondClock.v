`timescale 1ns / 1ps


module oneSecondClock(
		input clockIn,
		output clocksOut
	);
	// Creates 32 clock divisions, with an output signal for each one.
	parameter ndivs = 32;

	// Wires between flip-flops.
	wire [31:0] clockWires;


    assign clockWires[0] = clockIn;
    
   generate
    	genvar i;
        for(i = 0; i < ndivs - 1; i = i+1)

           begin:dividers
                tflipflop d(clockWires[i], 1'b1, 1'b1, clockWires[i+1]);
        end
    endgenerate

    assign clocksOut = clockWires[28];


endmodule
