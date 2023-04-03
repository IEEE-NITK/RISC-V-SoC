// Single Port RAM : as one address line for both read/write operations
// ports
// i_we : write enable
// i_addr : input address
// i_data : input data to be stored in RAM
// o_data : output data from RAM
// i_clk : clock

`default_nettype none

module ram (i_we, i_addr, i_data, o_data, i_clk);

parameter ADDR_WIDTH = 16;
parameter DATA_WIDTH = 8;

input wire i_we, i_clk;
input wire [ADDR_WIDTH-1:0] i_addr;
input wire [DATA_WIDTH-1:0] i_data;

output reg [DATA_WIDTH-1:0] o_data;

// RAM declaration
reg [DATA_WIDTH-1:0] RAM [2**ADDR_WIDTH-1:0];

always @(posedge i_clk) begin
    if (i_we) begin  // write operation
        RAM[i_addr] <= i_data;
    end
end

always @(*) begin
    o_data <= RAM[i_addr];
end

endmodule


// Path: ram_tb.v
// Testbench for RAM

module tb_ram();

integer  i;
parameter ADDR_WIDTH = 16;
parameter DATA_WIDTH = 8;

reg i_we, i_clk;
reg [ADDR_WIDTH-1:0] i_addr;
reg [DATA_WIDTH-1:0] i_data;

wire [DATA_WIDTH-1:0] o_data;

// Instantiate the Unit Under Test (UUT)
ram UUT (
    .i_we(i_we),
    .i_addr(i_addr),
    .i_data(i_data),
    .o_data(o_data),
    .i_clk(i_clk)
);

initial begin
    i_clk = 0;
    forever i_clk = #5 ~i_clk;
end

initial begin
    #0 i_we = 1;
    for (i = 0; i < 32; i = i + 1) begin
        i_addr = i; i_data = $urandom_range(0, 255);
        @(posedge i_clk);
        end

    // #0 i_we = 0;
    // for (i = 0; i < 32; i = i + 1) begin
    //      i_addr = i;
    // end
end

initial begin
    $dumpfile("ram.vcd");
    $dumpvars(0, tb_ram);
    $display("Starting simulation...");
    #100 $finish;
end


endmodule