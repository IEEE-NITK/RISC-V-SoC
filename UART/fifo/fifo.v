`default_nettype none
module fifo(i_clk, i_rd, i_wr, i_data, o_full, o_data, o_empty, o_fill);

parameter BW = 8; // bits per element
parameter FLEN = 8; // FIFO length
input wire i_clk;
input wire i_rd;
input wire i_wr;
input wire [BW-1:0] i_data;

output reg o_full;
output reg [BW-1:0] o_data;
output reg o_empty; // true if FIFO is empty
output reg [FLEN-1:0] o_fill;// to check number of items in FIFO memory

wire wr_fifo = i_wr && !o_full; // write to internal memory
wire rd_fifo = i_rd && !o_empty; // read and return o_data from internal memory

// define the memory size of 2^8
// 256 memory words each containing a bit range of 7 to 0
reg [BW-1:0] fifo_mem[0:(1<<FLEN)-1];

// give the pointers one extra bit, so to use all 2^N elements
reg [FLEN:0] wr_addr, rd_addr;

// to read next data in the fifo
reg [FLEN-1:0] rd_next;

// Write to the FIFO Memory
initial wr_addr = 0;
always @(posedge i_clk) begin
    if (wr_fifo) begin
        wr_addr <= wr_addr + 1'b1;
    end
end

always @(posedge i_clk) begin
    if (wr_fifo) begin
        fifo_mem[wr_addr] <= i_data;
    end
end

// Read and return from the FIFO Memory (some violation initiallly not sure what?)
initial rd_addr = 0;
always @(posedge i_clk) begin
    if (rd_fifo) begin
        rd_addr <= rd_addr + 1'b1;
    end
end

always @(*) begin
    o_data = fifo_mem[rd_addr];
end

always @(*) begin
    o_fill = wr_addr - rd_addr;
end

always @(*) begin
    o_empty = (o_fill == 0);
end

// o_full will be full when it will overflow
always @(*) begin
    o_full = (o_fill == {1'b1, {{FLEN}{1'b0}}} );
end

always @(*)
    rd_next = rd_addr[FLEN-1:0] + 1;
endmodule