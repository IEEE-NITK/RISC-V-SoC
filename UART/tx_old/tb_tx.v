module tb_tx();

parameter DATAWIDTH = 8;

reg clk, i_reset, i_transmit;
reg [DATAWIDTH-1:0] i_data;
wire o_tx_data;

// reg [DATAWIDTH-1:0] var = 8'd11001100;
integer j;

transmitter UUT(clk, i_data, i_reset, i_transmit, o_tx_data);
initial begin
    clk = 0;
    forever clk = #5 ~clk;
end

initial begin
    $dumpfile("tb_tx.vcd");
    $dumpvars(0, tb_tx);
end

initial begin
    #0 i_reset = 1; i_transmit = 0; i_data = 0;
    #10 i_data = 8'b0011_0011; i_reset=0; i_transmit = 1;
    for(j=0; j<104160; j=j+1) begin // taking around 11 baudrate
        @(posedge clk);
    end
    #10 i_data = 8'b1010_1010; // taking around 10+1 baudrate
    for(j=0; j<104160; j=j+1) begin
        @(posedge clk);
    end
    #10 i_data = 8'b0000_1111; // taking around 10+1 baudrate
    for(j=0; j<135408; j=j+1) begin
        @(posedge clk);
    end
    $finish;
end


endmodule
