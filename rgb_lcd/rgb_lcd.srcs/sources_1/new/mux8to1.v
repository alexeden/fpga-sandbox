`timescale 1ns / 1ps


module mux8to1(
    input [7:0] d,
    input [2:0] select,
    output q
    );

	assign q = d[select];
endmodule
