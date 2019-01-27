`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// RGB LCD
// 
//////////////////////////////////////////////////////////////////////////////////


module lcd(
		input clk,
		input BTNC,
		input BTNU,
		input BTND,
		input [15:0] sw, 
		output [15:0] led,
		output [7:0] JA
    );
	reg A0, RST, CS;
	wire SCLK, SID, fullCount;
	reg [7:0] instruction;
	reg [15:0] initCounter;
	reg [2:0] counter; // 3-bit counter

	clockDivider #(.clockdivs(5)) clockdiv(clk, SCLK);
	mux8to1 instrmux(instruction, counter, SID);
	//shiftRegister shiftreg(SCLK, instruction, CS, SID);


	// JA[0] Pin 1: Orange, SID
	// JA[1] Pin 2: Green, A0
	// JA[2] Pin 3: Purple, /CS
	// JA[4] Pin 7: Yellow, SCLK
	// JA[5] Pin 8: Blue, /RST
	assign JA[0] = SID;		// Serial Input Data
	assign JA[1] = A0;		// Register Select
	assign JA[2] = CS;		// Chip Select
	assign JA[4] = SCLK;	// Serial Clock
	assign JA[5] = RST;		
	assign JA[6] = sw[1];
	assign JA[7] = sw[2];

	assign led[15:13] = counter[2:0];

	// Counter control
	always @(posedge SCLK) begin
		if (!CS) begin
			counter <= counter + 1;
		end

	end

	and
		a1(fullCount, counter[2], counter[1], counter[0]);

	// Display init
	always @(posedge BTNC) begin
		CS = 1'b0;
		RST = 1'b0;
		initCounter = 0;
		instruction = 8'b10101111;
		while(initCounter != 16'hFFFF) begin
			initCounter = initCounter + 1;
		end
		RST = 1'b1;
		$display("initCount done at ", $time);

	end

	// Chip UNselect at full count.
	always @(posedge fullCount) begin
		CS = 1'b1;
		counter <= 0;
	end




	initial begin
		CS = 1'b1; // Active LOW
		RST = 1'b1; // Active LOW
		A0 = 1'b0;		// Register Select (A0) is HIGH for display data, LOW for control data.
		counter = 3'b000;
		initCounter = 16'h0000;
	end

	always @(posedge SCLK) begin
		
	end



endmodule
