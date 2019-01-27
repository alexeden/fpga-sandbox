`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Interprets the position of the 16 switches as a binary value
// and displays the value on the seven-segment dsiplays.
// 
//////////////////////////////////////////////////////////////////////////////////


module sw2hex(
        input clk,
        input [15:0] sw, 
        output [15:0] led,
        output [6:0] seg,
        output [7:0] an
    );
    
    //reg [1:0] ctrlCount;
   // wire slowclk;
    
   // parameter ndisp = 4;
    //wire [6:0] dispSegs3, dispSegs2, dispSegs1, dispSegs0;
    
    //clockdivider #(.clockdivs(16)) clkdiv(clk, slowclk);

    displayDriver display(clk, sw, an, seg, led[7:0]);
    
    assign led[15:8] = sw[15:8];
    /*initial ctrlCount = 2'b00;
        
    sevenSegDisplay disp0(sw[3:0], dispSegs0);
    sevenSegDisplay disp1(sw[7:4], dispSegs1);
    sevenSegDisplay disp2(sw[11:8], dispSegs2);
    sevenSegDisplay disp3(sw[15:12], dispSegs3);
    
    // Decode the clock counter to enable individual displays.
    decoder_2to4 dispEn(.s(ctrlCount), .out(an));
   
    // Multiplex the display segment signals.
    sevenBit_4to1MUX #(.bitw(7)) segMUX(
        .s(ctrlCount), 
        .in0(dispSegs0), .in1(dispSegs1), .in2(dispSegs2), .in3(dispSegs3),
        .out(seg)
    );

    always @(posedge slowclk)
        ctrlCount = ctrlCount + 1;*/
    
   
endmodule
/*

module decoder_2to4(
    input [1:0] s,
    output reg [7:0] out
    );

    always @(s) 
    begin
        case(s)
            0:  out = 8'b11111110;
            1:  out = 8'b11111101;
            2:  out = 8'b11111011;
            3:  out = 8'b11110111;
        endcase
    end
endmodule

module clockdivider(
    input clock,
    output divclock
    );
    
    parameter ndiv = 2;
    wire[ndiv:0] c;
    genvar i;
    assign c[0] = clock;
    assign divclock = c[ndiv];
    
    generate
        for(i = 0; i <= ndiv-1; i = i+1)
            begin:dividers
                tflipflop d(c[i], 1'b1, 1'b1, c[i+1]);
            end
    endgenerate
    
endmodule  



module sevenBit_4to1MUX(
    input[1:0] s, 
    input [6:0] in0, 
    input [6:0] in1, 
    input [6:0] in2, 
    input [6:0] in3,
    output reg[6:0] out 
    );
    
    parameter bitw = 7;
    
    always @(s) 
        begin
            case(s)
            0:out = in0;
            1:out = in1;
            2:out = in2;
            3:out = in3;
            endcase
        end
endmodule

module sevenSegDisplay(
		input [3:0] swVal,
		output reg [6:0] segs
	);
	always @(swVal)
		begin
			case(swVal)
				0: segs = 7'b1000000;
				1: segs = 7'b1111001;
				2: segs = 7'b0100100; 
				3: segs = 7'b0110000;//0000110;
				4: segs = 7'b0011001;//1001100;
				5: segs = 7'b0010010;//0100100;
				6: segs = 7'b0000010;//0100000;
				7: segs = 7'b1111000;//0001111;
				8: segs = 7'b0000000;
				9: segs = 7'b0010000;//0000100;
				'hA: segs = 7'b0001000;
				'hb: segs = 7'b0000011;//1100000;
				'hC: segs = 7'b1000110;//0110001;
				'hd: segs = 7'b0100001;//1000010;
				'hE: segs = 7'b0000110;//0110000;
				'hF: segs = 7'b0001110;//0111000;
				default: segs = 7'b0000000; // 0
			endcase 
		end
endmodule*/