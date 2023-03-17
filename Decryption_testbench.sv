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
  e_data = 79;


@(negedge clock);
  key = 8'b10100000;
  e_data = 80;
 
  repeat(4)@(negedge clock);
  $display("data: ",data);
  repeat(15)
	begin
	@(negedge clock);
	$display("data: ",data);
	end

  repeat(20) @(negedge clock);
$finish;
end

  initial begin
    $dumpfile("enc.vcd");
    $dumpvars;
  end
  
endmodule
