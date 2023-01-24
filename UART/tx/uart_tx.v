/* initial assumptions
baud_rate =9600
baud_count = clock_freq/ baud_rate = 100MHz/9600 = 10416
counter for 10 bits: 1-bit start, 8-bits data, 1-bit stop 
IDLE: nothing happens
DATA: transfer of data in this state
*/

`default_nettype none
module transmitter(clk, i_data, i_reset, i_transmit, o_tx_data);

parameter DATAWIDTH = 8;
localparam IDLE = 2'b00, DATA = 2'b01;

input wire clk;
input wire [DATAWIDTH-1:0] i_data;
input wire i_reset;
input wire i_transmit;

output reg o_tx_data;

reg [1:0] STATE;
reg [3:0] counter; 
reg [13:0] baud_count;
reg [9:0] shift_reg; //serial transmit data through UART to the board
reg shift; // signal to shifting bits in UART
reg load; // start loading the data in shift_reg, and add start and stop bits
reg clear; // reset the bit_count for UART Transmission

always @(posedge clk) begin
    if (i_reset) begin
        STATE <= IDLE;
        baud_count <= 0;
        counter <= 0;
        shift_reg <= 0;
    end 
    else begin
        baud_count <= baud_count + 1;
        if (load)
        shift_reg <= {1'b1, i_data, 1'b0}; 
        if (baud_count == 10415) begin
            STATE <= DATA; 
            baud_count <= 0; 
        if (clear)
            counter <= 0;
        if (shift) 
            shift_reg <= shift_reg >> 1; 
        if (counter != 10) 
            counter <= counter + 1;
        else 
            counter <= 0;
        end
    end
end
// FSM
always @(posedge clk) begin
   load <= 0;
   shift <= 0;
   clear <= 0;
   o_tx_data <= 1; // should go low, for transmission to start

   case(STATE)
   IDLE: begin
    if (i_transmit) begin 
    STATE <= DATA;
    load <= 1;
    shift <= 0;
    clear <= 0;
    end 
    else 
    begin
    STATE <= IDLE;
    o_tx_data <= 1;
    end
   end

   DATA: begin
    if (counter == 10) begin 
        STATE <= IDLE;
        clear <= 1;
    end
    else begin 
        STATE <= DATA;
        o_tx_data <= shift_reg[0];
        shift <= 1;
    end
   end
   default: STATE <= IDLE;
   endcase
end
endmodule

