// Code your testbench here
// or browse Examples

module top;
parameter N = 8;
  reg clock;
  reg [N-1:0] key;
  reg [N-1:0] IN;
  reg sel;
  wire [N-1:0] OUT;
  wire valid_key;
  reg [N-1:0] temp;

MTE /*#(.N(N))*/ TP (clock, key, IN, sel, OUT, valid_key);

initial begin
clock=1'b0;
forever #5 clock = ~clock;
end

initial begin

//@(negedge clock);
  $display("Test 1"); //check that it encrypts
  sel = 1'b1; //encrypt
  key = 'h13; 
  IN = 8'b11111111;
  //e_data1 = {32{8'hfe}};


  repeat(10) @(negedge clock); //wait some time for valid data (need to actually find out exact number of clock cycles required)
  $display("output: %d", OUT); //output data to determine if correct

  $display("test 2"); //check that it decrypts
  sel = 1'b0;
  //key = 'h13;
  //IN = OUT;
  //e_data1 = {32{8'hfe}};
  //repeat (20) @(negedge clock);
  #0 //update the clock so we get decrypted data instead of encrypted (shouldn't do this in final design)
  $display("output: %d", OUT); //output decrypted data (later set this to check if the output is the same as the first input for automation);

  // ********havent actually looked at this part yet, just been trying numbers with the first half
  $display("Test 3");
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
