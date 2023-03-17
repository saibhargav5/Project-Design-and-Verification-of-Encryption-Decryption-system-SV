module top;
parameter N= 8;
  
  bit clock;
  reg [N-1:0]key;
  reg [N-1:0]e_data;
  wire [N-1:0]data;

  decryption DUT(clock,key,e_data,data);

initial begin
clock=1'b0;
forever #5 clock = ~clock;
end

initial begin

//@(negedge clock);
  key = 8'd0;
  e_data = 8'd1;


  @(negedge clock);
  key = 8'hF;
  e_data = 8'd2;


@(negedge clock);
  key = 8'b10101010;
  e_data = 8'b01010101;
 
  @(negedge clock);


  repeat(20) @(negedge clock);
$finish;
end

  initial begin
    $dumpfile("enc.vcd");
    $dumpvars;
  end
  
endmodule
