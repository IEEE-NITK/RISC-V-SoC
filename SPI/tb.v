module tb();

parameter SPI_MODE = 0;
parameter CLKS_PER_HALF_BIT = 2;

integer i;
reg i_Rst_L;
reg i_Clk;

reg [7:0] i_TX_Byte;
reg i_TX_DV;
reg i_SPI_MISO;

wire o_TX_Ready;
wire o_RX_DV;
wire [7:0] o_RX_Byte;

wire o_SPI_Clk;
wire o_SPI_MOSI;

// module instantiation

SPI_Master UUT(i_Rst_L, i_Clk, i_TX_Byte, i_TX_DV, o_TX_Ready, o_RX_DV, o_RX_Byte, o_SPI_Clk, i_SPI_MISO, o_SPI_MOSI);

initial begin 
    i_Clk = 0;
    forever i_Clk = #5 ~i_Clk;
end

// dumpfile
initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
end

initial begin

    #0 i_Rst_L = 0; i_TX_Byte = 8'hAB; i_TX_DV = 1'b1;
    #10 i_Rst_L = 0;

    for (i = 0; i < 8; i = i + 1) begin
        i_TX_DV = 1'b1;
        i_SPI_MISO = ($random%2);
        @(posedge i_Clk);
    end

    #10 i_Rst_L = 0; i_TX_Byte = 8'h56; i_TX_DV = 1'b1;
    #10 i_Rst_L = 0;

    for (i = 0; i < 8; i = i + 1) begin
        i_TX_DV = 1'b1;
        i_SPI_MISO = ($random%2);
        @(posedge i_Clk);
    end

    #100 $finish;
end




endmodule