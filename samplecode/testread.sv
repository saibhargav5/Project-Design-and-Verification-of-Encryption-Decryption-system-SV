//this file tests reading in text, displaying it for us to confirm it worked, as well as converting it into bits for an input, and then outputting that as hex

module top;

string data;
string sub;

  //pseudo input data
bit [255:0] IN;

int fd;
int read;

int diff;

int temp;

initial
	begin
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
				$display("hex data: %h\n\n", IN);
          //move to next 32 byte chunk
				diff += 32;
				end
			end
		else
			begin
			$display("couldn't read");
			$finish;
			end

		end


	end


endmodule
