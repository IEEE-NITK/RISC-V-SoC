// We haven't interfaced with baud counter yet :
// initial assumptions
// baud_rate = 115200
// baud_count = clock_freq/ baud_rate = 100MHz/115200 = 868

`default_nettype none
module tx(i_clk, i_wr, i_data, o_busy, o_uart_tx);

parameter BW = 8; // 8 bits per word
parameter [23:0] CLOCKS_PER_BAUD = 24'd868;
localparam [3:0] START	= 4'h0,
		BIT_ZERO	= 4'h1,
		BIT_ONE		= 4'h2,
		BIT_TWO		= 4'h3,
		BIT_THREE	= 4'h4,
		BIT_FOUR	= 4'h5,
		BIT_FIVE	= 4'h6,
		BIT_SIX		= 4'h7,
		BIT_SEVEN	= 4'h8,
		LAST		= 4'h8,
		IDLE		= 4'hf;

//following 8N1 format
input wire i_clk;
input wire i_wr;
input wire [BW-1:0] i_data;

output reg o_busy;
output reg o_uart_tx;

reg [3:0] state;
reg [23:0] baud_counter;
reg [BW:0] local_data;
reg baud_stb;

// initial {o_busy,state} = {0,IDLE};
initial state = IDLE;
initial o_busy = 0;
always @(posedge i_clk) begin
   if ((i_wr)&&(!o_busy)) 
   begin
		// Immediately start us off with a start bit
        o_busy <= 1'b1;
        state <= START;
    end
	else if (baud_stb)
	begin
		if (state == IDLE)  
        begin// Stay in IDLE 
            o_busy <= 1'b0;
            state <= IDLE;
        end
		else if (state < LAST) 
        begin
			o_busy <= 1'b1;
			state <= state + 1'b1;
        end 
        else 
        begin// Wait for IDLE
			o_busy <= 1'b0;
            state <= IDLE;
        end
    end
end

initial local_data = 9'h1ff;
always @(posedge i_clk) begin
    if((i_wr) && (!o_busy))
        local_data <= {i_data, 1'b0};
    else if (baud_stb)
        local_data <= {1'b1, local_data[8:1]};
end

assign o_uart_tx = local_data[0];

initial baud_stb = 1'b1;
initial baud_counter = 0;
always @(posedge i_clk) begin
    if((i_wr) && (!o_busy))
    begin
        baud_counter <= CLOCKS_PER_BAUD - 1'b1;
        baud_stb <= 1'b0;
    end
    else if(!baud_stb)
    begin
        baud_stb <= (baud_counter == 24'h01);
        baud_counter <= baud_counter - 1'b1;
    end
    else if(state != IDLE)
    begin
        baud_counter <= CLOCKS_PER_BAUD - 24'h01;
        baud_stb <= 1'b0;
    end
end

endmodule

