`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Implements a 32-bit counter.
// Counter value is displayed on 7-segment display.
// Speed of counting is controlled by switches. (1 = 1 clock division)
//////////////////////////////////////////////////////////////////////////////////


module clockSpeedControl(
		input clk,
        input [15:0] sw, 
        output [15:0] led,
        output [6:0] seg,
        output [7:0] an
    );
	wire [4:0] speed; // Counter speed, max value of 32 clock divisions
	reg [31:0] counter;
	wire [31:0] clockdivs; // 32 clock divisions fed into multiplexer for counter clock.
	wire clock2; // Output of the multiplexed clock signal.


	// Create the clock dividers and their parallel signals.
	parallelClockDivider clocks(clk, clockdivs);

	// Assign the leds to the switches.
	assign led[4:0] = sw[4:0];
	assign led[15] = clock2;
	//assign led[11:5] = an[7:0];

	// Assign the switches to the speed.
	assign speed = sw[4:0];

	// Assign the second clock to the speed.
	assign clock2 = clockdivs[speed];

	// Set the initial values.
	initial begin
		counter = 8'h99;
	end

	// Initialize the display driver.
	displayDriver display(clk, counter, an, seg);


	


	// Increment the counter at the clock2 edge.
	always @(posedge clock2, posedge sw[15])
	begin
		if(sw[15]) begin
			counter = 0;
		end 
		else begin
			//$display("Clock2 pulse at ", $time, ", counter %d, speed %d", counter, speed);
			counter = counter + 1;
		end 
		
	end


endmodule


module parallelClockDivider(
		input clockIn,
		output[31:0] clocksOut
	);
	// Creates 32 clock divisions, with an output signal for each one.
	parameter ndivs = 32;
	reg RESET;

	// Wires between flip-flops.
	wire [31:0] clockWires;



    tflipflop first(clockIn, RESET, 1'b1, clockWires[0]);
    
   generate
    	genvar i;
        for(i = 0; i < ndivs - 1; i = i+1)

           begin:dividers
                tflipflop d(clockWires[i], RESET, 1'b1, clockWires[i+1]);
        end
    endgenerate

    assign clocksOut = clockWires;

    initial begin
    	RESET = 1;
    	#1 RESET = 0;
    end


endmodule