`timescale 1ns / 1ps


module oneBitAdder(
		input A,
		input B,
		input Cin,
		output S,
		output Cout
    );

	wire AxorB, orIn1, orIn2;

	xor
		xor1(AxorB, A, B),
		xor2(S, AxorB, Cin);

	and
		and1(orIn1, AxorB, Cin),
		and2(orIn2, A, B);

	or
		or1(Cout, orIn1, orIn2);

endmodule
