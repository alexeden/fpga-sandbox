`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Controls the 8, seven-segment displays.
//////////////////////////////////////////////////////////////////////////////////


module displayDriver(
	input Clock,
    input [31:0] value,
    output [7:0] NOTan, 		// Digit enable (select)
    output [6:0] seg
    );

	wire [7:0] anodeSelect;
	assign NOTan[7:0] = ~anodeSelect[7:0];


	// Create the 3-bit (max 8) control signal.
	// Controls value demuxing of 32-bit display value to 4-bit subvalues.
	// 8-bit decoded form is used to control digit select (enable).
	reg [2:0] control;

	// Create the 4-bit wire that runs from the demux output to the segment translator.
	wire [3:0] digitbinary;

	// Number of digits to be used.
	wire [2:0] digits;// = 8;

	// Create a slowed down Clock signal.
	wire dividedclock;

	// Bring the Clock freque8ncy down to a level low enough for display.
	defparam cd.clockdivs = 14;
	clockDivider cd(Clock, dividedclock);

    // Count the control signal upwards. If it hits the number of digits, reset it.
    always @(posedge dividedclock) 
    begin
    	//$display("display driver: current digit control value %d with %d digits for value %b", control, digits, value);
    	if(control < digits)
    		control = control + 1;
    	else begin
    		control = 0;
    	end
    end

    // Initialize the 32-bit signal demultiplexer.
    valueDemux valdemux(control, value, digitbinary);

    // Feed the individual digit binary value to the segment encoder.
    segmentEncoder segenc(digitbinary, seg);

    //Decode the control counter to the digit enable.
    decoder3to8 dec38(control, anodeSelect);

    // Set the number of digits.
    digitCounter digcount(value, digits);

	initial begin
		control = 1;
	end;

endmodule

module valueDemux(
		input [2:0] s,
		input [31:0] fullvalue,
		output reg [3:0] subvalue
	);
	// Receives the 32 value bits. The 3-bit switch value controls
	// which 4-bit section of the value is sent to the segment translator.

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


module segmentEncoder(
		input [3:0] digitvalue,
		output reg [6:0] segmentcode
	);

	// Receives the 4-bit digit to be displayed and translates it to the segment code.
	always @(digitvalue)
		begin
			case(digitvalue)
				0: segmentcode = 7'b1000000;
				1: segmentcode = 7'b1111001;
				2: segmentcode = 7'b0100100; 
				3: segmentcode = 7'b0110000;//0000110;
				4: segmentcode = 7'b0011001;//1001100;
				5: segmentcode = 7'b0010010;//0100100;
				6: segmentcode = 7'b0000010;//0100000;
				7: segmentcode = 7'b1111000;//0001111;
				8: segmentcode = 7'b0000000;
				9: segmentcode = 7'b0010000;//0000100;
				'hA: segmentcode = 7'b0001000;
				'hb: segmentcode = 7'b0000011;//1100000;
				'hC: segmentcode = 7'b1000110;//0110001;
				'hd: segmentcode = 7'b0100001;//1000010;
				'hE: segmentcode = 7'b0000110;//0110000;
				'hF: segmentcode = 7'b0001110;//0111000;
				default: segmentcode = 7'b0000000; // 0
			endcase 
		end

endmodule


module decoder3to8(
		input [2:0] i,
		output [7:0] d
	);

	// Decodes the 3-bit control signal.
	wire [2:0] ni;
	not 
		n2(ni[2], i[2]),
		n1(ni[1], i[1]),
		n0(ni[0], i[0]);
	and
		a7(d[7], i[2], i[1], i[0]),
		a6(d[6], i[2], i[1], ni[0]),
		a5(d[5], i[2], ni[1], i[0]),
		a4(d[4], i[2], ni[1], ni[0]),
		a3(d[3], ni[2], i[1], i[0]),
		a2(d[2], ni[2], i[1], ni[0]),
		a1(d[1], ni[2], ni[1], i[0]),
		a0(d[0], ni[2], ni[1], ni[0]);
endmodule

module encoder8to3(
		input [7:0] i,
		output reg [2:0] d
	);
	always @(i) begin
		
	if (i[7])
		d = 3'b111;
	else if (i[6])
		d = 3'b110;
	else if (i[5])
		d = 3'b101;
	else if (i[(4)])
		d = 3'b100;
	else if (i[(3)])
		d = 3'b011;
	else if (i[(2)])
		d = 3'b010;
	else if (i[(1)])
		d = 3'b001;
	else begin
		d = 3'b000;
	end
	end

endmodule



module digitCounter(
		input[31:0] value,
		output[2:0] digits
	);

	wire [7:0] digitOrs;

	generate
		genvar i;
		for(i = 0; i < 8; i = i + 1) 
			begin:ors
				or thisor(digitOrs[i], value[i * 4], value[i * 4 + 1], value[i * 4 + 2], value[i * 4 + 3]);
		end
	endgenerate

	encoder8to3 enc83(digitOrs, digits);



endmodule