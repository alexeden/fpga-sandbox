`timescale 1ns / 1ps

module oneSecondClock_tb(

    );

	reg Clock;
	wire clockOuts;
    always #(10) Clock = ~Clock;

	oneSecondClock osc(Clock, clockOuts);
	initial begin
		Clock = 1'b0;
	end
endmodule
