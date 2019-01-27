`timescale 1ns / 1ps

module clockDivider(
		input clockIn,
		output clockOut
	);
	parameter clockdivs = 1;


	wire[clockdivs-1:0] c;
    reg RESET;
    assign c[0] = clockIn;
    assign clockOut = c[clockdivs-1];
     genvar i;

    generate
        for(i = 0; i < clockdivs - 1; i = i+1) begin
            begin:dividers
                tflipflop d(
                    .CLOCK(c[i]),
                    .RESET(RESET),
                    .T(1'b1),
                    .Q(c[i+1])
                );

            end
        end
    endgenerate

    initial begin
     RESET = 0;
    	$display("display driver clockDivider has %d divisions", clockdivs);

    end


 
endmodule
