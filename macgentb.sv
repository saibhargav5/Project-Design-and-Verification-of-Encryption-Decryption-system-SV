module macgentb;

logic [255:0] MAC;

bit clk = 1;
bit [255:0] key;
bit [255:0] data;
bit enable;

//bit [7:0] temp_data;
bit [255:0] correct_mac;

macgen dut(clk, key, data, enable, MAC);

int i = 0;

always
	#1 clk = ~clk;

initial
	begin
	//set data to all 1s
	data = '1;
	//temp_data = 0;
	enable = 1;
	//set key to 0, and give 1 clock delay before verification
	@(negedge clk)
		key = 0;
	//repeat 256 times to set 1 in each bit slot of key starting with LSB after checking.
	repeat (256) @(negedge clk)
		begin
		//$display("key is %h\n", key);
		/*for(int i = 0; i < 32; i++)
			begin
			temp_data = temp_data + data[8*i+:8];
			end*/
		//calculate correct MAC
		correct_mac = data ^ key;
		//Check received MAC versus correct MAC
		if(MAC !== correct_mac)
			$display("ERROR!\ninputs:\nkey: %b\tdata: %h\tenable: %b\nReceived: %b\nExpected: %b", key, data, enable, MAC, correct_mac); 
		key[i] = 1'b1;	//set the next bit to 1
		i++;
		end
	//set data to all 1s
	data = 'b0;
	//temp_data = 0;
	i = 0;
	@(negedge clk)
		key = 0;
	//repeat 256 times, this time setting 1s from MSB
	repeat (256) @(negedge clk)
		begin
		/*for(int i = 0; i < 32; i++)
			begin
			temp_data = temp_data + data[8*i+:8];
			end*/
		correct_mac = data ^ key;
		if(MAC !== correct_mac)
			$display("ERROR!\ninputs:\nkey: %b\tdata: %h\tenable: %b\nReceived: %b\nExpected: %b", key, data, enable, MAC, correct_mac); 
		key[255 - i] = 1'b1;
		i++;
		end

	//set data to 10s repeated
	data = 'b10;
	//temp_data = 0;
	i = 0;
	@(negedge clk)
		key++;
	//repeat 256 times setting bits to 1, starting from LSB
	repeat (256) @(negedge clk)
		begin
		/*for(int i = 0; i < 32; i++)
			begin
			temp_data = temp_data + data[8*i+:8];
			end*/
		correct_mac = data ^ key;
		if(MAC !== correct_mac)
			$display("ERROR!\ninputs:\nkey: %b\tdata: %h\tenable: %b\nReceived: %b\nExpected: %b", key, data, enable, MAC, correct_mac); 
		key[i] = 1'b1;
		i++;
		end

	//set data to 01s repeated
	data = 'b01;
	//temp_data = 0;
	i = 0;
	@(negedge clk)
		key++;
	//repeat 256 times setting bits to 1, starting from MSB
	repeat (256) @(negedge clk)
		begin
		/*for(int i = 0; i < 32; i++)
			begin
			temp_data = temp_data + data[8*i+:8];
			end*/
		correct_mac = data ^ key;
		if(MAC !== correct_mac)
			$display("ERROR!\ninputs:\nkey: %b\tdata: %h\tenable: %b\nReceived: %b\nExpected: %b", key, data, enable, MAC, correct_mac); 
		key[255 - i] = 1'b1;
		i++;
		end


	@(negedge clk)
		$display("Done.\n\n");
		$finish;

	end


endmodule
