`timescale 1ns / 1ps

module top(
    input clk,
    output [3:0] led
    );
//Simple counter

reg [7:0] counter = 0;
always@(posedge clk) begin
    if (counter < 100) counter <= counter +1;
    else counter <= 0;
end
//10% duty cycle
assign led [0] =(counter<10) ? 1:0;

//30% duty cycle
assign led [1] =(counter<30) ? 1:0;

//50% duty cycle
assign led [2] =(counter<50) ? 1:0;

//70% duty cycle
assign led [3] =(counter<70) ? 1:0;

endmodule
