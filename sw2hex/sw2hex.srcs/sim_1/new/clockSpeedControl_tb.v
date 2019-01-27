`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module clockSpeedControl_tb(

    );

	reg clk;
	reg [4:0] sw;
	wire [15:0] led;
    wire [6:0] seg;
    wire [7:0] an;

    // Create a simulation clock.
    always #(1) clk = ~clk;
    always #(100) sw = sw+1;


	clockSpeedControl csc(clk, sw, led, seg, an);

initial begin
	clk = 1'b0;
	sw = 1'b0;
	$display("done");
end


endmodule
