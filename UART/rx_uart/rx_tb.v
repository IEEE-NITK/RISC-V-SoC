module tb_rx();
integer i;
integer j;
reg clk;
reg i_rx_data;
wire o_wr;
wire [7:0] o_data;

receiver uut(clk, i_rx_data, o_wr, o_data);
initial begin
    clk=0;
    forever clk = #5 ~clk;
end

reg [9:0]data_in = 10'b111011010;
initial begin
$monitor ("[$monitor] time=%0t i_rx_data=%b o_wr=%b o_data=%b", $time, i_rx_data, o_wr, o_data); 

for (i=0;i<10;i=i+1) 
begin
    for(j=0; j<10416; j=j+1) 
    begin 
    @(posedge clk);
    end
    i_rx_data = data_in[i];
end

data_in = 10'b1111000110;
for (i=0;i<10;i=i+1) 
begin
    for(j=0; j<10416; j=j+1) 
    begin 
    @(posedge clk);
    end
    i_rx_data = data_in[i];
end

data_in = 10'b1110001110;
for (i=0;i<10;i=i+1) 
begin
    for(j=0; j<10416; j=j+1) 
    begin 
    @(posedge clk);
    end
    i_rx_data = data_in[i];
end
$finish;
end 
endmodule