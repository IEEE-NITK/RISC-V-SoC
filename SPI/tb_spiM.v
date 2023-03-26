module tb_spiM();

integer i;
parameter SPI_MODE = 0;
parameter CLKS_PER_HALF_BIT = 2;
parameter MAIN_CLK_DELAY = 5;
parameter DATAWIDTH = 8;

reg i_reset;
reg i_clk;

//Master Specific
reg [DATAWIDTH-1:0] i_tx_data;
reg i_tx_valid;
reg i_spi_MISO;


wire o_spi_clk;
wire o_spi_MOSI;
wire o_tx_ready;
wire o_rx_valid;
wire [DATAWIDTH-1:0] o_rx_data;

// module instantiation
spiMaster UUT(i_reset, i_clk, i_tx_data, i_tx_valid, o_tx_ready, o_rx_valid, o_rx_data, o_spi_clk, i_spi_MISO, o_spi_MOSI);

initial begin 
    i_clk = 0;
    forever i_clk = #5 !i_clk;
end

// dumpfile
initial begin
    $dumpfile("tb_spiM.vcd");
    $dumpvars(0, tb_spiM);
end

initial begin

    #0 i_reset = 1; i_tx_data = 8'hAB; i_tx_valid = 1'b0;
    #10 i_reset = 0; 

    for (i = 0; i < 16; i = i + 1) begin
        i_tx_valid = 1'b1;
        i_spi_MISO = ($random%2);
        @(posedge i_clk);
    end
    #100 $finish;
end


endmodule