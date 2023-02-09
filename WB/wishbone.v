//Building a simple Wishbone Bus Master

`default_nettype none
module wb_master(i_clk, i_reset, i_stb, i_word, o_busy, o_wb_cyc, o_wb_stb,
o_wb_addr, o_wb_data, i_wb_stall, i_wb_ack, i_wb_err, o_stb, o_word, o_wb_we);

parameter DW = 32;
//
// localparam [1:0]	RSP_SUB_DATA =	2'b00,
// 				RSP_SUB_ACK =	2'b01,
// 				RSP_SUB_ADDR =	2'b10,
// 				RSP_SUB_SPECIAL=2'b11;

// state parameters
localparam [1:0] WB_READ_REQUEST = 2'b00,
                 WB_WRITE_REQUEST = 2'b01,
                 WB_SET_ADDRESS = 2'b10,
                 WB_RESET = 2'b11;


localparam [33:0] RSP_WRITE_ACKNOWLEDGEMENT = {2'b01, 32'h0};
input wire i_clk, i_reset;

//
input wire i_stb;
input wire [33:0] i_word; // the top 2-bits of these 34-bit for signaling
output reg o_busy;

//
output reg o_wb_cyc;
output reg o_wb_stb;
output reg o_wb_we;
output reg [DW-1:0] o_wb_addr, o_wb_data;

//
input wire i_wb_stall, i_wb_ack, i_wb_err;
input wire [DW-1:0] i_wb_data;

//
output reg  o_stb;
output reg [33:0] o_word;

//
wire i_rd, i_wr;

// 
wire i_bus; // i_bus to capture whether we have a read or write request
wire i_addr;
wire i_special; // ye kya hai
wire newaddr;

assign i_rd = (i_stb) && (i_word[33:32] == 2'b00);
assign i_wr = (i_stb) && (i_word[33:32] == 2'b01);

assign i_bus = (i_stb) && (i_word[33] == 1'b0);
// says acknowledge an address that has been set, so this is to happen 
// before any read or write
assign i_addr = (i_stb) && (i_word[33:32] == 2'b10);
assign i_special = (i_stb) && (i_word[33:32] == 2'b11); // I think this is reset

initial o_wb_cyc = 0;
initial o_wb_stb = 0;
initial newaddr = 0;
initial o_stb = 0;

reg [1:0] wb_state;

always @(posedge i_clk) begin
    if ((i_reset) || ((i_wb_err) && (o_wb_cyc))) begin
        o_wb_cyc <= 1'b0;
        o_wb_stb <= 1'b0;
        newaddr <= 1'b0;
        o_stb <= 1'b1;
        o_busy <= 1'b0;
    end 

    // IDLE state
    else if ((i_stb) && (!o_busy)) begin 
        newaddr <= 1'b0;

        if(i_addr) begin
            if (i_word[31]) o_wb_addr <= i_word[29:0] + o_wb_addr;
            else o_wb_addr <= i_word[29:0];

            newaddr <= 1'b1;
            inc <= !i_word[0];

        end
    end

// need to understand this part eh
    if (newaddr) begin
        o_stb <= 1'b1;
        o_word <= {2'b10, o_wb_addr, 1'b0, !inc};
     end
     o_wb_we <= i_wr;

// on a read or write request, activate the bus and go to bus request state
if (i_bus) begin
    o_wb_cyc <= 1'b1;
    o_wb_stb <= 1'b1;
    o_busy <= 1'b1;
end
if (i_wr) o_wb_data <= i_word[31:0];

// BUS REQUEST STATEs
else if (o_wb_stb) begin
    newaddr <= 1'b0;

    if (!i_wb_stall) begin
        o_wb_stb <= 1'b0;
        o_wb_addr <= o_wb_addr + inc;
    end

    if (i_wb_ack) begin
        o_wb_cyc <= 1'b0;
        o_rsp_stb <= 1'b1;
        if (o_wb_we)
            o_rsp_word <= RSP_WRITE_ACKNOWLEDGEMENT;
        else
            o_rsp_word <= {2'b00, i_wb_data};
    end

    if ((!i_wb_stall) && (i_wb_ack))
            o_wb_cyc <= 1'b0;      // chances we receive an ACK while request has yet to go out, so drop the CYC line
    end

    else if (o_wb_cyc) begin

    // BUS WAIT STATE
    newadaddr <= 1'b0;
    if (i_wb_ack) 
    begin

            o_wb_cyc <= 1'b0;
            o_busy <= 1'b0;
            o_rsp_stb <= 1'b1;
            if (o_wb_we)
                o_rsp_word <= RSP_WRITE_ACKNOWLEDGEMENT;
            else
                o_rsp_word <= {2'b00, i_wb_data};
    end else 
    begin

            if (i_bus) begin
                o_wb_cyc <= 1'b1;
                o_wb_stb <= 1'b1;
            end
    end
    end
end

assign o_busy = o_wb_cyc;

always @(posedge i_clk) begin
    if (!o_wb_cyc)
        o_wb_we <= i_wr;
end
endmodule