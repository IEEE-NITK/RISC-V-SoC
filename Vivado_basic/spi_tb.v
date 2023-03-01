module spi_tb;

  reg clk;
  reg reset;
  reg [15:0]datain;

  wire spi_cs;
  wire spi_sclk;
  wire spi_data;
  wire [4:0]counter;

  spi_master dut (
     .clk(clk),
     .reset(reset),
     .counter(counter),
     .datain(datain),
     .spi_cs(spi_cs),
     .spi_sclk(spi_sclk),
     .spi_data(spi_data)
  );

  initial begin //clock signal
    clk = 0;
    reset = 1;
    datain = 0;
  end

  always #5 clk=~clk;

initial begin
#10  reset = 1'b0;
#10 datain = 16'hA569;
#335 datain = 16'h2563;
#335 datain = 16'h9B63;
#335 datain = 16'h6A61;
#335 datain = 16'hA265;
#335 datain = 16'h7564;

end
