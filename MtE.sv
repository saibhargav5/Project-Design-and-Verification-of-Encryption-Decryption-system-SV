module MTE(clock,key,IN,sel,OUT,valid_key);
  parameter N = 256;
  input clock;
  input [255:0]key;
  input [255:0]IN;
  input sel;
  output reg valid_key;
  output reg [255:0]OUT;
  
  wire [255:0]R1_out;
  reg [511:0]EnReg;
  reg [511:0] DeReg;
  reg [511:0] OutEn;
  reg [511:0] OutDe;
  reg [255:0]EMAC;
  reg [255:0]DMAC;
  reg EQ;
  reg and_out;
  reg [511:0] out1;
  reg [511:0] OutEn1;
  assign OutEn1 = {OutEn[511:256],OutEn[255:0]}; // Encrpted output(cipher text)
  reg [255:0] OUT1;
  assign EnReg = {IN,EMAC}; // to store input and the MAC generated for input in a single reg
  //assign OUT = OutEn[255:0];

  //**********we need one more mux that uses this to determine if we have the correct MAC and determine if we should send correct data or 0s (only should happen when decrypting)
  assign and_out = (~sel & EQ); 

  macgen M1(clock, key, IN[255:0], 1'b1, EMAC); // Generate MAC for Encryption 
  
  encryption #(.N(N)) EN1(clock,key,EnReg[255:0],OutEn[255:0]); // Encrypt MAC part of the input
  encryption #(.N(N)) EN2(clock,key,EnReg[511:256],OutEn[511:256]); // Encrypt data part of the input

  //**********need the input of this to not be the output of encryption for the final version
  decryption #(.N(N)) DE1(clock,key,OutEn[255:0],OutDe[255:0]); // Decrypting the MAC part of the cypher text 
  decryption #(.N(N)) DE2(clock,key,OutEn[511:256],OutDe[511:256]); // Decrypting the data part of the cipher text

  macgen #(.N(N)) M2(clock, key, OutDe[511:256], 1'b1, DMAC); // generate MAC for comparison during decryption
  mac_compare #(.N(N)) C1(clock, OutDe[255:0], DMAC, valid_key);  // compare MAC generated during decrption and the MAC that is decrypted from the cipher text
  //assign OUT = OutDe[15:8]; // plain text output
  Muxnto1 #(.N(N)) FM(mux_out,'0,OutDe[511:256],valid_key);
  Muxnto1 #(.N(N)) DM (OUT, OutDe[2 * N-1 : N], OutEn[2 * N - 1 : N], sel); //determine if we are outputting encrypted data or decrypted data



  //**********need to write eof searcher function that loops through the IN per byte and compares if the value is 0x3
	 //genvar i;
	 //generate
	 initial begin
	  for(int i = 0; i < $clog2(256); i++) begin
		//if character is eof
		if(IN[8*i+:7] == 3)
			begin
			$display("Found eof");
			$finish;
			end
	$display("didn't find eof");
        end
        end
       //endgenerate

endmodule

// MAC Compare
module mac_compare #(parameter N=256)(clock, mac1, mac2, EQ);
input clock;
input [N-1:0] mac1;
input [N-1:0] mac2;
output reg EQ;

always_comb
 begin
   EQ = (mac1 === mac2) ? 1'b1 : 1'b0;
 end
endmodule

// MUX 
module Muxnto1(Y, V0, V1, S);
parameter N = 8;
output [N-1:0] Y;
input [N-1:0] V0;
input [N-1:0] V1;
input S;

assign Y = S ? V1 : V0;
endmodule
