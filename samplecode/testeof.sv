module top;

bit [255:0] data;

initial
	begin
	//insert some bits
	data = 256'b0111010001101000011010010111001100100000011010010111001100100000011100110110111101101101011001010010000001110100011001010111001101110100011010010110111001100111001000000111010001100101011110000111010000000011; 
	//loop until you get to the last character
	for(int i = 0; i < $clog2(256); i++)
		//if character is eof
		if(data[8*i+:7] == 3)
			begin
			$display("Found eof");
			$finish;
			end
	$display("didn't find eof");

	end


endmodule
	
