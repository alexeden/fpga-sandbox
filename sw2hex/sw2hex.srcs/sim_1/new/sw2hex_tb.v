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
    integer i;    
    wire slowclk;
    wire tffout;
    
    sw2hex tb(
        .clk(clock),
        .sw(switches),
        .led(lights),
        .seg(segments),
        .an(anodes)
    ); 
    

    
    
    // Create the clock.
    initial clock = 1'b0; 
    always #(2) clock = ~clock;
  
      
    //clockdivider  #(.ndiv(16)) clockdiv(clock, slowclk);
    // tflipflop tflip(clock, 1'b1, 1'b1, tffout);
      
    // Set initial values.
    initial 
    begin
   // #1 switches = 0;
    
    for(i = 0; i < 65536; i = i + 1)
    begin
        #1000 switches = i;
    end
    end
    
endmodule
