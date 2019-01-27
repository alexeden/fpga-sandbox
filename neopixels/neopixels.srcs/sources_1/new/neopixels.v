`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// TH + TL = 1250ns +/- 300ns
// T0H = 400ns, T0L = 850ns
// T1H = 800ns, T1L = 450ns
// Individual Periods +/- 150ns
//
// Reset Period > 50,000ns
//
// 100,000,000 Hz = 10ns
// 1 div = 20ns
// 2 div = 40ns
// 3 div = 80ns
// 4 div = 160ns
// 5 div = 320ns
// 6 div = 640ns
// 7 div = 1280ns
//
//
// Use 2 div signal as divisor.
// For signal 0: cutoff at posedge-triggered count of 6
// For signal 1: cutoff at posedge-triggered count of 11
//////////////////////////////////////////////////////////////////////////////////


module neopixels(
		input clk,
		input [15:0] sw,
		output [15:0] led,
		output reg data
    );

	// Setup the clock signals.
	wire clock7;
	assign clock7 = clocks[6];
	wire clock3;
	assign clock3 = clocks[2];
	wire [6:0] clocks;
	sevenClockDivider divs(clk, clocks);


	assign led[15:14] = sw[15:14];
	assign led[6:0] = clocks;
	assign led[7] = clock7;
	assign led[8] = clock3;
	assign led[12:9] = clock3counter;
	//assign led[13] = dropSignal;

	

	// Current output bit to be encoded.
	wire bit = sw[0];
	reg [3:0] clock3counter;

	// Main clock signal.
	always @(posedge clock7) begin
		data <= 1'b1;
	end

	always @(posedge clock3) begin
		if (data) begin
			if ((!bit && clock3counter == 4) || (bit && clock3counter == 9)) begin
				data <= 1'b0;
				clock3counter <= 4'b0;

			end 
			else begin
				clock3counter <= clock3counter + 1;
			end
		end
	end
	initial begin
		clock3counter = 0;
	end


/*
	// Data drop signal.
		reg dropSignalReg;

	wire dropSignal;
	assign dropSignal = (!bit) ? ~(clock3counter[3] & ~clock3counter[2] & ~clock3counter[1] & clock3counter[0]) :  ~(~clock3counter[3] & ~clock3counter[2] & clock3counter[1] & ~clock3counter[0]);
	
	always @(posedge clock3) begin
		dropSignalReg <= dropSignal;
	end

	// Clock 3 counter.
	assign clock3counter[0] = clock3;
	tflipflop trff1(clock3counter[0], dropSignalReg, 1'b1, clock3counter[1]);
	tflipflop trff2(clock3counter[1], dropSignalReg, 1'b1, clock3counter[2]);
	tflipflop trff3(clock3counter[2], dropSignalReg, 1'b1, clock3counter[3]);

	// If drop signal raised, reset everything.
	always @(negedge dropSignal) begin
		data <= 1'b0;
		$display("Drop signal triggered for bit %d", bit, " at time ", $time);
	end

*/

	
endmodule

module tResetFlipFlop(
		input clk,
		input reset,
		output reg Q
	);
	initial Q = 1'b0;


	always @(posedge clk, negedge reset) begin
		if (!reset) 
			Q <= 1'b0;
		else 
			Q <= 1'b1 ^ Q;
	end


endmodule

module sevenClockDivider(
		input clockIn,
		output[6:0] clockOut
	);


	wire[6:0] c;
    assign c[0] = clockIn;
  //  assign clockOut[6:0] = c[6:0];
  	tflipflop first(clockIn, 1'b1, 1'b1, clockOut[0]);
     genvar i;

    generate
        for(i = 0; i < 6; i = i+1)
            begin:dividers
                tflipflop d(clockOut[i], 1'b1, 1'b1, clockOut[i+1]);
        end
    endgenerate


 
endmodule
