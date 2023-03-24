
module top;
  parameter N= 8;
  parameter NRANDOM = 1000;
  
  reg clock;
  reg [N-1:0]key;
  reg [N-1:0]data;
  reg [N-1:0]MAC;
  wire [N-1:0]e_data;
  wire [N-1:0]e_MAC;

  encryption DUT(clock,key,data,e_data);

initial begin
clock=1'b0;
forever #5 clock = ~clock;
end

initial begin
  $monitor("key:%h data:%h e_data:%h",key,data,e_data);
//@(negedge clock);
  
  repeat(NRANDOM)
    begin
    key = $random;
    data = $random;
      @(negedge clock);
    end
  
  repeat(20) @(negedge clock);
$finish;
end

  initial begin
    $dumpfile("enc.vcd");
    $dumpvars;
  end
  
endmodule

