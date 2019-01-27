`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module clockSpeedControl_tb(

    );

	reg clk;
	reg [4:0] sw;
	wire [15:0] led;
    wire [6:0] seg;
    //wire [6:0] seg2;
    wire [7:0] an;
    //wire [7:0] an2;
    //wire[31:0] clockdivs;
    //reg [31:0] value;

    // Create a simulation clock.
    always #(1) clk = ~clk;
    always #(10000) sw = sw+1;
    //always #(1) value = value+1;


	clockSpeedControl csc(clk, sw, led, seg, an);
	//displayDriver display(clk, value, an2, seg2);
	//parallelClockDivider clocks(clk, clockdivs);

initial begin
	clk = 1'b0;
	sw = 1;
	//value = 1;
	$display("done");
end


endmodule
