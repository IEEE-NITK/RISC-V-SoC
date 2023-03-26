/*
SPI_MODE can be 0..3. configuration of one of 4 modes is based on 
CPOL(Clock POLarity): default value of the spi_clk when the bus is idle
CPHA(Clock PHAse): determines which edge of the clk data is sampled
CLKS_PER_HALF_BIT: set the integer number of clks for each half-bit of SPI data

we would be creating 25 KHz SPI_clk
i_clk let's say is 100MHZ


CPOL: Clock Polarity
CPOL=0 means clock idles at 0, leading edge is rising edge
CPOL=1 means clock idles at 1, leading edge is falling edge

CPHA: Clock Phase
CPHA=0 means the "out" side changes data- trailing edge
             the "in" side captures data- leading edge 
CPHA=1 means the "out" side changes data- leading edge
             the "in" side captures data- trailing edge
*/

`default_nettype none
module spiMaster(i_reset, i_clk, i_tx_data, i_tx_valid, 
o_tx_ready, o_rx_valid, o_rx_data, o_spi_clk, i_spi_MISO, o_spi_MOSI);


parameter DATAWIDTH = 8;
parameter SPI_MODE = 0;
parameter CLKS_PER_HALF_BIT = 2;

//control/data signals
input wire i_reset;
input wire i_clk;

// TX (MOSI) 
input wire [DATAWIDTH-1:0] i_tx_data;
input wire i_tx_valid;  // valid pulse with i_tx_data
output reg o_tx_ready;  // transmit ready for next byte


// RX (MISO)
output reg o_rx_valid; // data valid pulse
output reg [DATAWIDTH-1:0] o_rx_data; 


// SPI interface (all runs at spi clk domain)
output reg o_spi_clk;
input wire i_spi_MISO;
output reg o_spi_MOSI;

// all runs are w.r.t to spi clk domain
// r_*_* is registering the incoming data

wire w_CPOL;
wire w_CPHA;
reg [$clog2(CLKS_PER_HALF_BIT*2)-1:0] r_spi_clk_count;
reg r_spi_clk;
reg [4:0] r_spi_clk_edges;
reg r_leading_edge;
reg r_trailing_edge;
reg r_tx_valid;
reg [DATAWIDTH-1:0] r_tx_data;

reg [2:0] r_tx_bit_count;
reg [2:0] r_rx_bit_count;

assign w_CPOL = (SPI_MODE == 2) | (SPI_MODE == 3);
assign w_CPHA = (SPI_MODE == 1) | (SPI_MODE == 3);
// let's generate spi_clk
// spiClk SCK(i_clk, i_reset, i_tx_valid, o_tx_ready, o_spi_clk);
always @(posedge i_clk)begin
    if (i_reset) begin
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
            
            if (r_spi_clk_count == CLKS_PER_HALF_BIT*2-1) begin 
                r_trailing_edge <= 1;
                r_spi_clk_count <= 0;
                r_spi_clk <= ~r_spi_clk;
            end
            else if (r_spi_clk_count == CLKS_PER_HALF_BIT-1) begin
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

// register i_tx_data when data is valid
always @(posedge i_clk) begin
    if (i_reset) begin
        r_tx_data <= 8'b0;
        r_tx_valid <= 1'b0;
    end

    else begin
        r_tx_valid <= i_tx_valid; // 1 clk cycle delay
        if (i_tx_valid)
        begin
            r_tx_data <= i_tx_data;
        end
    end
end

// MOSI data
always @(posedge i_clk) begin
    if (i_reset) begin
        o_spi_MOSI <= 1'b0;
        r_tx_bit_count <= 3'b111; // MSB first
    end
    else begin
        if (o_tx_ready) 
            r_tx_bit_count <= 3'b111;
        else if (r_tx_valid & ~w_CPHA) begin
            o_spi_MOSI <= r_tx_data[7];
            r_tx_bit_count <= 3'b110;
        end
        else if ((r_leading_edge & w_CPHA) | (r_trailing_edge & ~w_CPHA)) begin
            r_tx_bit_count <= r_tx_bit_count - 1;
            o_spi_MOSI <= r_tx_data[r_tx_bit_count];
        end
    end
end

// read MISO data
always @(posedge i_clk) begin
    if (i_reset) begin
        o_rx_data <= 8'b0;
        o_rx_valid <= 0;
        r_rx_bit_count <= 3'b111;
    end
    else begin
        // default assignment
        o_rx_valid <= 0; // goes high, saying we have received the byte

        if (o_tx_ready) begin
            r_rx_bit_count <= 3'b111;
        end
        else if ((r_leading_edge & ~w_CPHA) | (r_trailing_edge & w_CPHA)) begin
            o_rx_data[r_rx_bit_count] <= i_spi_MISO; //sample data
            r_rx_bit_count <= r_rx_bit_count - 1;

        if (r_rx_bit_count == 3'b000) begin
            o_rx_valid <= 1;
        end
        end
    end
end

// maybe to be extra sure that clk is synced properly
always @(posedge i_clk) begin
    if (i_reset) 
        o_spi_clk <= w_CPOL;
    else 
        o_spi_clk <= r_spi_clk;
end


endmodule

