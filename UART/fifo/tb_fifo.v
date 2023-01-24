`default_nettype none
module tb_fifo();
parameter BW = 8; // bits per element
parameter FLEN = 8; // FIFO length
reg i_clk;
reg i_rd;
reg i_wr;
reg [BW-1:0] i_data;

wire o_full;
wire [BW-1:0] o_data;
wire o_empty; // true if FIFO is empty
wire [FLEN-1:0] o_fill;// to check number of items in FIFO memory

integer i;
// Instantiate the Unit Under Test (UUT)
fifo UUT (
    .i_clk(i_clk),
    .i_rd(i_rd),
    .i_wr(i_wr),
    .i_data(i_data),
    .o_full(o_full),
    .o_data(o_data),
    .o_empty(o_empty),
    .o_fill(o_fill)
);

// clk
initial begin
    i_clk = 0;
    forever #5 i_clk = ~i_clk;
end

initial begin
#0 $display("Starting test"); 
#0 i_wr = 1; i_rd = 0;
for (i = 0; i < 10; i = i + 1) begin
    i_data = i;
    @(posedge i_clk);
end
for (i = 0; i < 10; i = i + 1) begin
    i_rd = 1;
    i_wr = 0;
    @(posedge i_clk);
end
#10 $display("Test finished");
$finish;
end

endmodule