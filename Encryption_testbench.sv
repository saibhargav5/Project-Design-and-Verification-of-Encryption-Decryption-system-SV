module top;
parameter N= 8;
  
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

//@(negedge clock);
  key = 8'd0;
  data = 8'd1;


  @(negedge clock);
  key = 8'hF;
  data = 8'd2;


@(negedge clock);
  key = 'h13;
  data = 'hFF;
 
  repeat(4)@(negedge clock);
  $display("e_data: ",e_data);
  repeat(15)
	begin
	@(negedge clock);
	$display("e_data: ",e_data);
	end
@(negedge clock);
  $display("e_data: ",e_data);



  


  repeat(20) @(negedge clock);
$finish;
end

  initial begin
    $dumpfile("enc.vcd");
    $dumpvars;
  end
  
endmodule
