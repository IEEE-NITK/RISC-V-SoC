`timescale 1ns / 1ps

module testbench;
reg clk =0;
wire [3:0] led;

top UUT (clk, led);
always #5 clk = ~clk;
endmodule
