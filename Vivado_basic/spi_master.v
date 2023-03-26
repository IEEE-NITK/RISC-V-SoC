module spi_master(
  input wire clk,
  input wire reset,
  input wire [15:0] datain,
  output wire spi_cs
  output wire spi_sclk
  output wire spi_data
  output [4:0]counter
);

reg[15:0] MOSI;
reg[4:0] count;
reg cs_l;
reg sclk;
reg[2:0]state;

always @(posedge clk or posedge reset)
if(reset) begin
	MOSI	<= 16'b0;
	count	<= 5'd16;
	cs_l	<= 1'b1;
	sclk	<= 1'b0;
end


else begin
case(state)

  0:begin
  sclk <= 1'b0;
  cs_l <= 1'b1;
  state <= 1
  end

  1:begin
  sclk <= 1'b0;
  cs_l <= 1'b0;
  MOSI <= datain[count-1];
  count <= count-1;
  state <= 2
  end


  2:begin
  sclk <= 1'b1;
  if (count > 0)
  state <= 1;
  else begin
    count <= 16;
  state <= 0;
    end
  end

  default:state<=0;
    
	endcase
end


assign spi_cs = cs_1;
assign spi_sclk = sclk;
assign spi_data = MOSI;
assign counter = count;
endmodule 


















