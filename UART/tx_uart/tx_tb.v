`timescale 1ns/1ns

module tx_tb;

reg i_clk;
reg i_wr;
reg [7:0] i_data;
wire o_busy;
wire o_uart_tx;

tx dut(i_clk, i_wr, i_data, o_busy, o_uart_tx);

initial begin
    i_clk = 0;
    forever #0.5 i_clk = ~i_clk;
end

initial begin

    i_wr = 1;
    i_data = 8'b01010110;
    #15627 i_wr = 0;
    #10000;
    i_data = 8'b01100101;
    i_wr = 1;
    #15626 i_wr = 0;
    #5000 $finish;
end

endmodule
