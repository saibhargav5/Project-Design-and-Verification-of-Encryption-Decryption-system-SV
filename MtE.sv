/*this module will take the 32 bytes of data and the key (on clock edges)
 it will instantiatee the decrypter, encrypter and macgen modules, and
 pass them the required information, and then will output take their outputs
 and output it to the user
 */
// NEW 
module MTE(clock,key,IN,sel,OUT,valid_key);
  parameter N = 8;
  input clock;
  input [N - 1:0]key;
  input [N - 1:0]IN;
  input sel;
  output reg valid_key;
  output reg [N - 1:0]OUT;
  
  wire [7:0]R1_out;
  reg [2 * N - 1:0]EnReg;
  reg [2 * N - 1:0] DeReg;
  reg [2 * N - 1:0] OutEn;
  reg [2 * N - 1:0] OutDe;
  reg [N - 1:0]EMAC;
  reg [N - 1:0]DMAC;
  reg EQ;
  reg and_out;
  reg [2 * N - 1:0] out1;
  reg [2 * N - 1:0] OutEn1;
 assign OutEn1 = {OutEn[15:8],OutEn[7:0]}; // Encrpted output(cipher text)
  reg [N - 1:0] OUT1;
 assign EnReg = {IN,EMAC}; // to store input and the MAC generated for input in a single reg
  //assign DeReg = {IN,EMAC};


  //**********we need one more mux that uses this to determine if we have the correct MAC and determine if we should send correct data or 0s (only should happen when decrypting)
  assign and_out = (~sel & EQ); 





  macgen #(.N(N)) M1(clock, key, IN[N-1:0], 1'b1, EMAC); // Generate MAC for Encryption 
  
  //always @(posedge clock)
   // begin
  //fork
  //  begin
  encryption #(.N(N)) EN1(clock,key,EnReg[N - 1:0],OutEn[N - 1:0]); // Encrypt MAC part of the input
  encryption #(.N(N)) EN2(clock,key,EnReg[2 * N - 1:N],OutEn[2 * N - 1:N]); // Encrypt data part of the input
  //  end
   // begin


  //**********need the input of this to not be the output of encryption for the final version
  decryption #(.N(N)) DE1(clock,key,OutEn[N - 1:0],OutDe[N - 1:0]); // Decrypting the MAC part of the cypher text 
  decryption #(.N(N)) DE2(clock,key,OutEn[2 * N - 1:N],OutDe[2 * N - 1 :N]); // Decrypting the data part of the cipher text





    //end
  //join
  //  end
  
  macgen #(.N(N)) M2(clock, key, OutDe[2 * N - 1:N], 1'b1, DMAC); // generate MAC for comparison during decryption
  mac_compare #(.N(N)) C1(clock, OutEn[N - 1:0], DMAC, EQ);  // compare MAC generated during decrption and the MAC that is decrypted from the cipher text
  //assign OUT = OutDe[15:8]; // plain text output
  Muxnto1 #(.N(N)) DM (OUT, OutDe[2 * N-1 : N], OutEn[2 * N - 1 : N], sel); //determine if we are outputting encrypted data or decrypted data



  //**********need to write eof searcher function that loops through the IN per byte and compares if the value is 0x3



endmodule

// MAC Compare
module mac_compare #(parameter N=8)(clock, mac1, mac2, EQ);
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

