`timescale 1ns / 1ps

module clockDivider(
		input clockIn,
		output clockOut
	);
	parameter clockdivs = 1;


	wire[clockdivs:0] c;
    assign c[0] = clockIn;
    assign clockOut = c[clockdivs];
     genvar i;

    generate
        for(i = 0; i <= clockdivs - 1; i = i+1)
            begin:dividers
                tflipflop d(c[i], 1'b1, 1'b1, c[i+1]);
        end
    endgenerate

    initial begin
    	$display("display driver clockDivider has %d divisions", clockdivs);
    end


 
endmodule
