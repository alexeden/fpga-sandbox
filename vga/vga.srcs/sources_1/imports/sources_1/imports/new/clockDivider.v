`timescale 1ns / 1ps

module clockDivider(
		input clockIn,
		output clockOut
	);
	parameter clockdivs = 1;
    reg [clockdivs:0] counter;

    always @(posedge clockIn) begin
        counter <= counter + 1;
    end
    assign clockOut = counter[clockdivs];
	

    initial counter = 0;
 
endmodule
