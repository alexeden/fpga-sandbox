`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// H 68Khz V 60Hz
// S232HL
//////////////////////////////////////////////////////////////////////////////////


module vga(
    input clk,
    input [15:0] sw,
    output [15:0] led,
    output [6:0] seg,
    output [7:0] an,
    output reg [3:0] vgaRed, vgaGreen, vgaBlue,
    output Hsync, Vsync
    );
wire dclk;
clockDivider cd(clk, dclk);
// registers for storing the horizontal & vertical counters
reg [10:0] hcount ;
reg [10:0] vcount;
assign led[15] = dclk;
	
// video structure constants
wire clr = sw[15];
/*parameter hpixels = 800;// horizontal pixels per line
parameter hpulse = 96; 	// hsync pulse length
parameter hfrontp = 752; 	// end of horizontal back porch
parameter hbackp = 16; 	// beginning of horizontal front porch

parameter vlines = 525; // vertical lines per frame
parameter vpulse = 2; 	// vsync pulse length
parameter vfrontp = 492; 		// end of vertical back porch
parameter vbackp = 10; 	// beginning of vertical front porch*/
parameter hpixels = 1904;// horizontal pixels per line
parameter hpulse = 152; 	// hsync pulse length
parameter hfrontp = 1672; 	// end of horizontal back porch
parameter hbackp = 80; 	// beginning of horizontal front porch

parameter vlines = 932; // vertical lines per frame
parameter vpulse = 3; 	// vsync pulse length
parameter vfrontp = 904; 		// end of vertical back porch
parameter vbackp = 1; 	// beginning of vertical front porch


assign led[9:0] = vcount;

always @(posedge clk or posedge clr) begin
	// reset condition
	if (clr == 1) begin
		hcount <= 0;
		vcount <= 0;
	end
	else begin
		if (hcount < hpixels - 1) begin
			hcount <= hcount + 1;
		end
		else begin
			hcount <= 0;
			if (vcount < vlines - 1) begin
				vcount <= vcount + 1;
			end
			else begin
				vcount <= 0;
			end

		end
		
	end
end

// generate sync pulses (active low)
assign Hsync = (hcount < hpulse) ? 0:1;
assign Vsync = (vcount < vpulse) ? 0:1;
always @(*)
begin
	if (vcount >= vbackp && vcount < vfrontp)
	begin
		// -----------------
		// display white bar
		if (hcount >= hbackp && hcount < (hbackp+80))
		begin
			vgaRed = 4'b1111;
			vgaGreen = 4'b1111;
			vgaBlue = 4'b1111;
		end
		// display yellow bar
		else if (hcount >= (hbackp+80) && hcount < (hbackp+160))
		begin
			vgaRed = 4'b1111;
			vgaGreen = 4'b1111;
			vgaBlue = 4'b0000;
		end
		// display cyan bar
		else if (hcount >= (hbackp+160) && hcount < (hbackp+240))
		begin
			vgaRed = 4'b0000;
			vgaGreen = 4'b1111;
			vgaBlue = 4'b1111;
		end
		// display vgaGreen bar
		else if (hcount >= (hbackp+240) && hcount < (hbackp+320))
		begin
			vgaRed = 4'b0000;
			vgaGreen = 4'b1111;
			vgaBlue = 4'b0000;
		end
		// display magenta bar
		else if (hcount >= (hbackp+320) && hcount < (hbackp+400))
		begin
			vgaRed = 4'b1111;
			vgaGreen = 4'b0000;
			vgaBlue = 4'b1111;
		end
		// display vgaRed bar
		else if (hcount >= (hbackp+400) && hcount < (hbackp+480))
		begin
			vgaRed = 4'b1111;
			vgaGreen = 4'b0000;
			vgaBlue = 4'b0000;
		end
		// display vgaBlue bar
		else if (hcount >= (hbackp+480) && hcount < (hbackp+560))
		begin
			vgaRed = 4'b0000;
			vgaGreen = 4'b0000;
			vgaBlue = 4'b1111;
		end
		// display black bar
		else if (hcount >= (hbackp+560) && hcount < (hbackp+640))
		begin
			vgaRed = 4'b1111;
			vgaGreen = 4'b0111;
			vgaBlue = 4'b0000;
		end
		// we're outside active horizontal range so display black
		else
		begin
			vgaRed = 0;
			vgaGreen = 0;
			vgaBlue = 0;
		end
	end
	// we're outside active vertical range so display black
	else
	begin
		vgaRed = 0;
		vgaGreen = 0;
		vgaBlue = 0;
	end
end


endmodule
