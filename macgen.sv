/*this will take in some data and then do some operation on it (on clock edges)
 it will take each chunk (32 bytes) of data and do some operation on it 
 and the key, and combine the result with the result from the last chunk of data's 
 result at the end this will have have a MAC that used the data from every chunk that
 we have read.
 */
 
module macgen #(parameter N = 8)(input clk, [N-1:0]key, [N-1:0]data, input enable,
            output [N-1:0] MAC);

//var [7:0] temp_mac;
//var [7:0] temp_data;

//assign MAC = temp_mac;

assign MAC = enable ? key ^ data : 0;


/*always_comb
	begin
	
	if(enable)
		begin
		//temp_data = data[7:0];
		for(int i = 0; i < 32; i++)
			begin
			temp_data += data[8*i+:8];
			end
		temp_mac = key ^ data;
		end
	else
		temp_data = 0;	
	end*/

endmodule
