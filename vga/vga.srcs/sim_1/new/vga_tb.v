`timescale 1ns / 1ps


module vga_tb(

    );

	reg clk;
    reg [15:0] sw;
    wire [15:0] led;
    wire [6:0] seg;
    wire [7:0] an;
    wire [3:0] vgaRed, vgaGreen, vgaBlue;
    wire Hsync, Vsync;

    // Setup clock
    always #(5) clk = ~clk;


    // Setup vga
    vga VGA(clk, sw, led, seg, an, vgaRed, vgaGreen, vgaBlue, Hsync, Vsync);

    wire slowClk;
    clockDivider cd(clk, slowClk);

    always @(posedge Vsync ) begin
    	$display("Vsync pulsed at ", $time);
    end
    initial begin
    	clk = 1;
    	sw = 0;
    end
endmodule
