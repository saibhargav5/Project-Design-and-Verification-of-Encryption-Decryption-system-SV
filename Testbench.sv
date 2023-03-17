/*module top;

reg clock;
reg [7:0]key;
reg [7:0]data;
reg [7:0]MAC;
wire [7:0]e_data;
wire [7:0]e_MAC;

encryption DUT(clock,key,data,MAC,e_data,e_MAC);

initial begin
clock=1'b0;
forever #5 clock = ~clock;
end

initial begin
//$monitor($time,"key=%b data=%b MAC=%b e_data=%b e_MAC=%b",key,data,MAC,e_data,e_MAC);

key = 8'b00000000; 
data = 8'b00000000; 
MAC = 8'b00000000;
@(negedge clock);
 
key = 8'b10101010; 
data = 8'b11110000; 
MAC = 8'b10000001;
@(negedge clock);

key = 8'b10011001; 
data = 8'b00000000; 
MAC = 8'b00000001;
@(negedge clock);

repeat(2) @(negedge clock);
$finish;
end

endmodule*/

// Code your testbench here
// or browse Examples
// Code your testbench here
// or browse Examples

/*module top;
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
  
endmodule*/

// Code your testbench here
// or browse Examples

module top;
parameter N = 256;
  reg clock;
  reg [N-1:0] key;
  reg [N-1:0] IN;
  reg sel;
  wire [N-1:0] OUT;
  wire valid_key;
  //wire [N-1:0] temp;

MTE #(.N(N)) TP (clock, key, IN, sel, OUT, valid_key);

initial begin
clock=1'b0;
forever #5 clock = ~clock;
end

initial begin

//@(negedge clock);
  sel = 1'b1;
  key = 'h0;
  IN = 'h1;
  //e_data1 = {32{8'hfe}};

  while(OUT[0] === 'x)
	  @(negedge clock);
  sel = 1'b0;
  key = 256'h0;
  IN = OUT;
  //e_data1 = {32{8'hfe}};

  @(negedge clock);
  sel = 1'b1;
  key = 8'hF;
  IN = 8'h2;
  //e_data1 = {32{8'h96}};

  @(negedge clock);
  sel = 1'b0;
  key = 8'hF;
  IN = 8'h6;
  //e_data1 = {32{8'h96}};

@(negedge clock);
  sel = 1'b1;
  key = 8'ha;
  IN = 8'h5;
  //e_data1 = {32{8'h14}};

  @(negedge clock);
  sel = 1'b0;
  key = 8'ha;
  IN = 8'h4;
  //e_data1 = {32{8'h96}};



  repeat(20) @(negedge clock);
	
$finish;
end

/*  initial begin
    $dumpfile("enc.vcd");
    $dumpvars;
  end*/
  
endmodule
/*
// TESTBENCH FOR BHUVAN MTE DESIGN
module top;
parameter N = 8;
  reg clock;
  reg [N - 1:0] key;
  reg [2 * N - 1:0] IN;
  reg sel;
  wire [2 * N - 1:0] OUT;
  wire valid_key;
  //wire [N-1:0] temp;

MTE #(.N(N)) TP (clock, key, IN, sel, OUT, valid_key);

initial begin
clock=1'b0;
forever #5 clock = ~clock;
end

initial begin
$monitor("sel = %b, key = %h, IN = %h, OUT = %h", sel,key,IN,OUT);
//@(negedge clock);
  sel = 1'b1;
  //sel = 1'b0;
  key = 8'hce;
  IN = 8'hac;
  //IN = 16'he62b;
  //e_data1 = {32{8'hfe}};

  while(OUT[0] === 'x)
	  @(negedge clock);
  sel = 1'b0;   // decrypting the cipher text for the above encryption (key= 8'hce and data= 8'hac)
  key = 8'hce;
  IN = 16'he62b; // cipher text for data= 8'hac with key= 8'hce    // here the expected out(decrytion output = 8'hac)
  //e_data1 = {32{8'hfe}};

  repeat(20) @(negedge clock);
$finish;
end

/*  initial begin
    $dumpfile("enc.vcd");
    $dumpvars;
  end*/
  
endmodule
