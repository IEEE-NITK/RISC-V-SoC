// BAUD_RATE = 9600
`default_nettype none
module receiver(clk, i_rx_data, o_wr, o_data);

parameter DATAWIDTH = 8;
localparam[3:0]	IDLE = 4'h0, 
		BIT_ZERO = 4'h1, 
		BIT_ONE = 4'h2,	
		BIT_TWO = 4'h3, 
		BIT_THREE = 4'h4, 
		BIT_FOUR = 4'h5, 
		BIT_FIVE = 4'h6, 
		BIT_SIX = 4'h7, 
		BIT_SEVEN = 4'h8, 
		STOP_BIT = 4'h9;
input wire clk;
input wire i_rx_data;
output reg o_wr;
output reg [DATAWIDTH-1:0] o_data;

reg [3:0] STATE;
reg [15:0] baud_count;
reg zero_baud;

reg ck_uart;
reg	q_uart;
initial ck_uart = 1'b1;
initial q_uart = 1'b1;
always @(posedge clk)
	{ck_uart, q_uart} <= {q_uart, i_rx_data};

initial baud_count = 0;
initial o_data = 0;
initial STATE = IDLE;
always@(posedge clk)
    if (STATE == IDLE) begin
        STATE <= IDLE;
        baud_count <= 0;
        // o_data <= 0;
        if (!ck_uart) begin     //when start bit is detected
            STATE <= BIT_ZERO;
            baud_count <= 15623;  // 10416 + 5208 - 1 ie: 1.5 baud, for the start bit of UART
        end
    end
    else if (zero_baud) begin
        STATE <= STATE+1;         // BIT_ZERO->BIT_ONE->......->STOP_BIT
        baud_count <= 10415;      //10416 - 1 ie: 1 baud
        if (STATE == STOP_BIT) begin
            STATE <= IDLE;
            baud_count <= 0;
        end
    end
    else
        baud_count <= baud_count-1'b1;
always @(*)
    zero_baud = (baud_count == 0);   //zero_baud is true when baud_count reaches zero and acts like a flag
always @(posedge clk)
    if((zero_baud)&&(STATE != STOP_BIT))
        o_data <= {ck_uart,o_data[7:1]};
initial o_wr = 1'b0;
always@(posedge clk)
    o_wr<=((zero_baud) && (STATE == STOP_BIT)); //o_wr signal becomes high when STOP_BIT is current state and baud_count==0 ie: all data bits have been received
endmodule


