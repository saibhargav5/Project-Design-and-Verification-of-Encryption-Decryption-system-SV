module top;

parameter N = 256;
parameter NRANDOM  = 500;

  logic clock;
  logic [255:0]key;
  logic [255:0]IN;
  logic sel;
  logic valid_key;
  logic [255:0]OUT;

string data;
string sub;

  //pseudo input data

int fd;
int read;

int diff;

int temp;
int total_count=0, pass_count=0, fail_count = 0;
MTE DUT(clock,key,IN,sel,OUT,valid_key);

typedef struct packed {
//logic [255:0] key;
logic [255:0] IN;
} TestCase;

TestCase Q[$];		// queue of testcases as deep as pipeline
TestCase  TC;

typedef struct packed {
	logic [255:0] exp_out;
}Exp_Testcase;

Exp_Testcase Q_Exp[$];
Exp_Testcase TC_Exp;

initial begin
clock = 1'b0;
forever #10 clock = ~clock;
end

task checkresults(input TestCase TC);

logic [255:0] exp_out;
exp_out = DUT.OUT;
  $display($time,"expected output:%d",DUT.OUT);
  total_count ++ ;
  if(exp_out != TC.IN) begin
	fail_count++;
  $display($time,"FAILED exp_out:%h IN:%d key:%h",exp_out,IN,key);
  end
  else begin
	pass_count++;
  $display($time,"PASSED exp_out:%h IN:%d key:%h",exp_out,IN,key);
  end
  $display("total count = %d pass count = %d fail count = %d",total_count,pass_count,fail_count);
endtask
	
initial begin
	repeat(11) @(negedge clock);
	while(Q.size() > 0)
        begin
	  TC = Q.pop_back();
	  checkresults(TC);
	  $display($time,"POP from queue:%p",TC);
	//repeat(10) @(negedge clock);
	  @(negedge clock);
        end
	//$finish;
end

initial
	begin
    			@(negedge clock);
        `ifdef USEFILE
		key = 256'b1;
		sel = 1'b0;
	fd = $fopen("./text.txt", "r");
	if(!fd) 
		begin
		$display("File not opened");	
		$finish;
		end
	while(!$feof(fd))
		begin
		//this will keep the newline character at the end of the string, but we need to keep
		//it, otherwise when we decrypt we will be missing the newlines
		read = $fgets(data, fd);
		//$display("binary: %b",data.substr(0, data.len()));
		//$display("substring > 32: %s",data.substr(32, data.len()-1));
		if(read != 0)
			begin
			//this is in our case where we want to read 32 characters
			diff = 0;
			//$display("bytes read: %d", read);
			while(diff < read)
				begin
           //check if there are 32 bytes left in the string
				if(read - diff < 32)
					begin
					temp = read-diff;
            //this loops from where we last printed of the string to the end of the 32 byte chunk, filling in 0s
					for(int i = temp; i < 32; i++)
						begin
						data.putc(i + diff, "0");
						//data[i] = "0";
						end
            //get the substring from where we left off to the end of the 32 byte chunk (cause the loop made it reach 32 bytes)
					sub = data.substr(diff, data.len()-1);
					$display("substring < 32: %s",sub);
					end
				else
						begin
              //get the substring from where we left off to the end of the 32 byte chunk
						sub = data.substr(diff, diff+31);
						$display("substring > 32: %s", sub);

						end
          
          //loop to convert each character into bits and then shift into IN
				for(int i = 0; i < 32; i++)
					IN = (IN << 8) | sub.getc(i);
				//$display($time,"hex data: %h\n\n", IN);
				$display($time,"decimal data: %d\n\n", IN);
          //move to next 32 byte chunk
				diff += 32;

				TC.IN = IN;
				//TC.key = key;
				Q.push_front(TC);
			       $display($time,"Q:%p",Q);	
				@(negedge clock);
				end
				//@(negedge clock);
				 repeat(20) @(negedge clock);
			end
		else
			begin
			$display("couldn't read");
			$finish;
			end
		end
	`endif
    
        `ifdef DIRECT
    $monitor($time,"key:%d IN:%d sel:%d OUT:%d",key,IN,sel,OUT);
   
   Applystimulus('1, 1 << 256,'0);
   Applystimulus('0, 1 << 256,'0);
   Applystimulus(1 << 255, 1 << 256,'0);
   Applystimulus('0, 1 >> 255,'0);
   Applystimulus({64{4'h7}},{64{4'h9}},'0);

 repeat(20) @(negedge clock);
  $finish;
  `endif
  
  repeat (NRANDOM)
		begin
		IN = $urandom_range(1,256);
		key = $urandom_range(1,256);
		sel = 1'b0;
                TC.IN = IN;
                Q.push_front(TC);
                $display($time,"PUSH in a queue:%p",Q);
                $display($time,"PUSH in a TC:%p",TC);
                $display($time,"key:%d IN:%d sel:%d OUT:%d",key,IN,sel,OUT);
		@(negedge clock);
		end
             repeat(20) @(negedge clock);
  $finish;
	end
 
        `ifdef DIRECT
task Applystimulus(input [255:0] in,input [255:0] in_key, input s);
	IN = in;
	key = in_key;
	sel = s;
    TC.IN = IN;
    Q.push_front(TC);
    $display($time,"PUSH in a queue:%p",Q);
    $display($time,"PUSH in a TC:%p",TC);
	@(negedge clock);
endtask

  `endif


endmodule
