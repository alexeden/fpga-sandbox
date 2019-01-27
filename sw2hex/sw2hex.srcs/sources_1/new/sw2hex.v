`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Reads 16 switches as binary digits and displays the equivalent hexadecimal
// value on 4 seven-segment displays.
// 
//////////////////////////////////////////////////////////////////////////////////

module sw2hex_top(
    input clk,
    input [15:0] sw, 
    output [15:0] led,
    output [6:0] seg,
    output [7:0] an
);
    
    reg [1:0] ctrlCount;

    displayDriver #(.digits(4)) display(clk, sw, an, seg);
    
    assign led[15:0] = sw[15:0]; 
   
endmodule