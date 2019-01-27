`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Interprets the position of the 16 switches as a binary value
// and displays the value on the seven-segment dsiplays.
// 
//////////////////////////////////////////////////////////////////////////////////


module sw2hex_tb( );
    reg [15:0] switches; 
    wire [15:0] lights;
    wire [6:0] segments;
    wire [7:0] anodes;
    reg clock;

    sw2hex tb(
        .clk(clock),
        .sw(switches),
        .led(lights),
        .seg(segments),
        .an(anodes)
    ); 
    

    
    
    // Create the clock.
    initial begin 
    clock = 1'b1; 
    switches = 1;
    end
    always #(10) clock = ~clock;
    always #(20) switches = switches + 1;
  
      
    
endmodule
