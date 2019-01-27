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
    wire [7:0] decodedcontrol;
    integer i;
    reg clock;

    // Create a simulation clock.
    parameter CLOCK_PERIOD = 5; 
    initial begin 
        clock = 1'b0; 
        value = 32'hA1234567;
    end
    always #(CLOCK_PERIOD/2) clock = ~clock;
    
    displayDriver dd(clock, value, decodedcontrol, segcode);
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
