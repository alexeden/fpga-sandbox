`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/19/2014 04:35:18 AM
// Design Name: 
// Module Name: displayDriver_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module displayDriver_tb(

	);


    reg [31:0] value; 
    ///wire [3:0] subvalue;
    wire [6:0] segcode;
    wire [7:0] anodeSelect;
    reg CLOCK;
    wire [2:0] digits;
    wire dividedClock;
    always #(5) CLOCK = ~CLOCK;
    reg inT;
    reg RESET;
    wire outT, outT2;

    
    displayDriver dd(CLOCK, value, anodeSelect, segcode);
    defparam cd.clockdivs = 12;
    clockDivider cd(CLOCK, dividedClock);
    initial begin
        CLOCK = 1;
        value = 1;
        inT = 1;
        RESET = 1;
        #1 RESET = 0;
    end
    always #(1) value = value + 8;
    always #(20) inT = ~inT;

    tflipflop tff(CLOCK, RESET, 1'b1, outT);
    tflipflop tff2(outT, RESET, 1'b1, outT2);

    digitCounter dcount(value, digits);
/*    valueDemux vdmux(control, value, subvalue);
 segmentEncoder segenc(subvalue, segcode);
    decoder3to8 d38(control, decodedcontrol);
    initial */

   // 

   		//#10 control = i;

        // Set initial values.
      /*  initial 
        begin        
        for(i = 0; i < 8; i = i + 1)
        begin
        #8 control = i;
        end
        end*/

endmodule
