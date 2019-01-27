`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Controls the 8, seven-segment displays.
//////////////////////////////////////////////////////////////////////////////////

module displayDriver(
	input   Clock,
    input   [31:0] value,
    output  [7:0] NOTan, 		// Digit enable (select)
    output  [6:0] seg
);

	wire [7:0] an;

	assign NOTan = ~an;

	// Create the 3-bit (max 8) control signal.
	// Controls value demuxing of 32-bit display value to 4-bit subvalues.
	// 8-bit decoded form is used to control digit select (enable).
	reg [2:0] control;
	initial 
	begin
		control = 0;
	end;

	// Create the 4-bit wire that runs from the demux output to the segment translator.
	wire [3:0] digitbinary;

	// Number of digits to be used.
	parameter digits = 8;

	// Create a slowed down Clock signal.
	wire dividedclock;

	// Bring the Clock frequecncy down to a level low enough for display.
	defparam cd.clockdivs = 12;
	clockDivider cd(Clock, dividedclock);

    // Count the control signal upwards. If it hits the number of digits, reset it.
    always @(posedge dividedclock)
    begin
    	$display("Divided clock pulsed at ", $time, " control value is %d", control);
    	if(control != digits - 1)
    		control = control + 1;
    	else 
    	   begin
    		  control = 0;
    	   end
    end

    // Initialize the 32-bit signal demultiplexer.
    valueDemux valdemux(control, value, digitbinary);

    // Feed the individual digit binary value to the segment encoder.
    segmentEncoder segenc(digitbinary, seg);

    //Decode the control counter to the digit enable.
    decoder3to8 dec38(control, an);

endmodule


// Receives the 32 value bits. The 3-bit switch value controls
// which 4-bit section of the value is sent to the segment translator.
module valueDemux(
    input [2:0] s,
	input [31:0] fullvalue,
	output reg [3:0] subvalue
);
	
	always @(*)
	begin
		case (s)
			0:	subvalue = fullvalue[3:0];
			1:	subvalue = fullvalue[7:4];
			2:	subvalue = fullvalue[11:8];
			3:	subvalue = fullvalue[15:12];
			4:	subvalue = fullvalue[19:16];
			5:	subvalue = fullvalue[23:20];
			6:	subvalue = fullvalue[27:24];
			7:	subvalue = fullvalue[31:28];
			default: subvalue = 0;
		endcase
	end
endmodule


// Receives the 4-bit digit to be displayed and translates it to the segment code.
module segmentEncoder(
    input      [3:0] digitvalue,
	output reg [6:0] segmentcode
);

	always @(digitvalue)
	begin
		case(digitvalue)
			'h0:    segmentcode = 7'b1000000;
			'h1:    segmentcode = 7'b1111001;
			'h2:    segmentcode = 7'b0100100; 
			'h3:    segmentcode = 7'b0110000;
			'h4:    segmentcode = 7'b0011001;
			'h5:    segmentcode = 7'b0010010;
			'h6:    segmentcode = 7'b0000010;
			'h7:    segmentcode = 7'b1111000;
			'h8:    segmentcode = 7'b0000000;
			'h9:    segmentcode = 7'b0010000;
			'hA:    segmentcode = 7'b0001000;
			'hb:    segmentcode = 7'b0000011;
			'hC:    segmentcode = 7'b1000110;
			'hd:    segmentcode = 7'b0100001;
			'hE:    segmentcode = 7'b0000110;
			'hF:    segmentcode = 7'b0001110;
			default: 
			        segmentcode = 7'b0000000; 
		endcase 
	end

endmodule


module decoder3to8(
	input  [2:0] i,
	output [7:0] d
);

	// Decodes the 3-bit control signal.
	wire [2:0] ni;
	
	not 
		n2(ni[2], i[2]),
		n1(ni[1], i[1]),
		n0(ni[0], i[0]);
	and
		a7(d[7], i[2],    i[1],   i[0]),
		a6(d[6], i[2],    i[1],   ni[0]),
		a5(d[5], i[2],    ni[1],  i[0]),
		a4(d[4], i[2],    ni[1],  ni[0]),
		a3(d[3], ni[2],   i[1],   i[0]),
		a2(d[2], ni[2],   i[1],   ni[0]),
		a1(d[1], ni[2],   ni[1],  i[0]),
		a0(d[0], ni[2],   ni[1],  ni[0]);
endmodule


module clockDivider(
	input  clockIn,
	output clockOut
);

	parameter clockdivs = 1;

	wire[clockdivs:0] c;
    
    assign c[0] = clockIn;
    assign clockOut = c[clockdivs];
    genvar i;

    generate
        for(i = 0; i <= clockdivs - 1; i = i+1)
            begin:dividers
                tflipflop d(c[i], 1'b1, 1'b1, c[i+1]);
        end
    endgenerate

    initial begin
    	$display("display driver clockDivider has %d divisions", clockdivs);
    end

endmodule


module tflipflop(
    input Clock,
	input Reset,	
	input En,
	output reg Q
);

	wire xorTtoD;

	initial Q = 1'b0;

	xor 
		g(xorTtoD, Q, En);

	always @(negedge Reset, posedge Clock)
	begin
		// Reset occurs when low.
		if(!Reset)
			Q <= 0;
		else
			Q <= xorTtoD;
	end

endmodule
