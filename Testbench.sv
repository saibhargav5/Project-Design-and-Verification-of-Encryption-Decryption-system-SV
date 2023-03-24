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
  int error_code;

MTE #(.N(N)) TP (clock, key, IN, sel, OUT, valid_key);

class rand_string;
	rand byte input_char[];
	rand bit [255:0] password;

	constraint str_len {input_char.size() == 32;}
	//remove strange characters such as DEL and eot
	constraint no_weird_char { foreach(input_char[i])
				input_char[i] inside {[32:126]};
			}
	

	//this function generates the string from the line of characters from the input_char
	function string gen_string();
		string input_string = "";
		//go through every byte and add to string.
		foreach(input_char[i])
			input_string = {input_string, string'(input_char[i])};
		

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
  


  for(j = 0; j < test_cases; j++)
	begin
	  if(!string_class.randomize())
		begin
		$display("Error randomizing!");
		$finish;
		end
	  string_input = string_class.gen_string();
	  if(verbose)
		begin
	  	$display("******Test Encrypt******"); //check that it encrypts
	  	$display("Input: %s\n", string_input);
		$display("Key: %d\n", string_class.password);
		end
	  sel = 1'b1; //encrypt
	  key = string_class.password; 
	  for(int i = 0; i < N / 8; i++)
		IN = (IN << 8) | string_input.getc(i);
	  
	  if(verbose)
	  	$display("input is: %h\n", IN);
	
	  repeat(10) @(negedge clock); //wait some time for valid data (need to actually find out exact number of clock cycles required)
	  if(verbose)
		begin  
		temp_output = "";
	  	for(int i = 0; i < N/8; i++)
			temp_output = {temp_output, string'(OUT[8*i+:7])};
	  	$display("output: %h\nString output: %s", OUT, temp_output); //output data to determine if correct
	
	  	$display("\n******Test Decrypt******"); //check that it decrypts
		end
	  sel = 1'b0;
	  
	  #0 //update the clock so we get decrypted data instead of encrypted (shouldn't do this in final design)
	  if(OUT !== IN)
		$display("Decrypted wrong.");
	  if(verbose)
		begin
		$display("output: %h\n", OUT); //output decrypted data (later set this to check if the output is the same as the first input for automation);
		temp_output = "";
		for(int i = 0; i < N/8; i++)
			temp_output = {temp_output, string'(OUT[8*i+:7])};
		$display("Output String: %s\n\n\n", temp_output);
		end
	end


  @(negedge clock)

  $display("Finished Running!");
  $display("Number of tests run: %d\n", j);
  $finish;
  
  end
  
endmodule
