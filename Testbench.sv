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
  reg [N-1:0] temp;
  string string_input;
  string temp_output;
  int verbose;
  int test_cases;
  int j;

MTE #(.N(N)) TP (clock, key, IN, sel, OUT, valid_key);

class rand_string;
	rand byte input_char[];
	rand bit [255:0] password;

	constraint str_len {input_char.size() == 257;}
	constraint no_eof { foreach(input_char[i])
				input_char[i] inside {[32:126]};
			}
	//constraint end_string { input_char[256] == 0;}

	//this function generates the string from the line of characters from the input_char
	function string gen_string();
		string input_string;
		//go through every byte and add to string.
		foreach(input_char[i])
			input_string = {input_string, string'(input_char[i])};
		//input_string.putc(256, 0);
		//input_string.putc(0, 100);
		//input_string.putc(1, 0);
		//$display("Here is the string: %s", input_string);
		return input_string;
	endfunction

endclass

rand_string string_class;


initial begin
clock=1'b0;
forever #5 clock = ~clock;
end

initial 
  begin
  test_cases = 10;
  if($test$plusargs("VERBOSE"))
	verbose = 1; 
  if($test$plusargs("EXTENSIVE"))
	test_cases = 100000;
  string_class = new;
  string_class.randomize();
  string_input = string_class.gen_string();
  //$display("rand_string value: %h", string_class.input_char);

//@(negedge clock);
  for(j = 0; j < test_cases; j++)
	begin
	  string_class.randomize();
	  string_input = string_class.gen_string();
	  if(verbose)
		begin
	  	$display("******Test Encrypt******"); //check that it encrypts
	  	$display("Input: %s", string_input);
		$display("Key: %d", string_class.password);
		end
	  sel = 1'b1; //encrypt
	  key = string_class.password; 
	  for(int i = 0; i < 32; i++)
		IN = (IN << 8) | string_input.getc(i);
	  //e_data1 = {32{8'hfe}};
	  if(verbose)
	  	$display("input is: %h", IN);
	
	  repeat(10) @(negedge clock); //wait some time for valid data (need to actually find out exact number of clock cycles required)
	  if(verbose)
		begin  
		temp_output = "";
	  	for(int i = 0; i < 32; i++)
		temp_output = {temp_output, string'(OUT[8*i+:7])};
	  	$display("output: %h\nString output: %s", OUT, temp_output); //output data to determine if correct
	
	  	$display("******Test Decrypt******"); //check that it decrypts
		end
	  sel = 1'b0;
	  //key = 'h13;
	  //IN = OUT;
	  //e_data1 = {32{8'hfe}};
	  //repeat (20) @(negedge clock);
	  #0 //update the clock so we get decrypted data instead of encrypted (shouldn't do this in final design)
	  if(OUT !== IN)
		$display("Decrypted wrong.");
	  if(verbose)
		$display("output: %h\n\n\n", OUT); //output decrypted data (later set this to check if the output is the same as the first input for automation);
	end


  @(negedge clock)

  $display("Finished Running!");
  $display("Number of tests run: %d\n", j);
  $finish;
  
  end
  
endmodule
