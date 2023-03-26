`default_nettype none
module spiClk(i_clk, i_reset, i_tx_valid, o_tx_ready, o_spi_clk);

parameter SPI_MODE = 0;
parameter CLKS_PER_HALF_BIT = 2;
parameter DATAWIDTH = 8;

input wire i_clk;
input wire i_reset;
input wire i_tx_valid;

output reg o_spi_clk;
output reg o_tx_ready;

wire w_CPOL;
wire w_CPHA;

// assuming SPI mode = 0
assign w_CPOL = 0;
assign w_CPHA = 0;

reg [$clog2(CLKS_PER_HALF_BIT*2)-1:0] r_spi_clk_count;
reg r_spi_clk;
reg [4:0] r_spi_clk_edges;
reg r_leading_edge;
reg r_trailing_edge;

assign o_spi_clk = r_spi_clk;

always @(posedge i_clk)begin
    if(i_reset) begin
        o_tx_ready <= 1'b0;
        r_spi_clk_edges <= 5'b0;
        r_leading_edge <= 1'b0;
        r_trailing_edge <= 1'b0;
        r_spi_clk <= w_CPOL;
        r_spi_clk_count <= 0;

    end
    else begin

        r_leading_edge <= 1'b0;
        r_trailing_edge <= 1'b0;

        if (i_tx_valid) begin
            o_tx_ready <= 1'b0;
            r_spi_clk_edges <= 16; // total edges are always 16
        end

        else if (r_spi_clk_edges > 0) begin
            o_tx_ready <= 1'b0;
            r_spi_clk_edges <= r_spi_clk_edges - 1;
            if(r_spi_clk_count == CLKS_PER_HALF_BIT*2-1) begin 
                r_trailing_edge <= 1;
                r_spi_clk_count <= 0;
                r_spi_clk <= ~r_spi_clk;
            end
            else if(r_spi_clk_count == CLKS_PER_HALF_BIT-1) begin
                r_leading_edge <= 1'b1;
                r_spi_clk_count <= r_spi_clk_count + 1;
                r_spi_clk <= ~r_spi_clk;
            end
            else begin
                r_spi_clk_count <= r_spi_clk_count + 1;
        end
        end
        else begin
            o_tx_ready <= 1;
        end
    end
end
endmodule

module tb_clk();

reg i_clk;
reg i_reset;
reg i_tx_valid;

wire o_spi_clk;
wire o_tx_ready;
integer i;

//module instantiation
spiClk SCK(i_clk, i_reset,i_tx_valid,o_tx_ready, o_spi_clk);

initial begin
    i_clk = 0;
    forever i_clk = #5 ~i_clk;
end

initial begin
    #0 i_reset = 1; i_tx_valid = 0;
    #10 i_reset  = 0; i_tx_valid = 1;
    #10 i_tx_valid = 0;
    for(i=0;i<17; i=i+1) begin
        @(posedge i_clk);
    end
    #10 i_tx_valid=1;
    #10 i_tx_valid=0;
    for(i=0;i<17; i=i+1) begin
    @(posedge i_clk);
end
    $finish;
end
endmodule


