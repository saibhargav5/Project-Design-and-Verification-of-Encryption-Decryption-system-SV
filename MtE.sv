/*this module will take the 32 bytes of data and the key (on clock edges)
 it will instantiatee the decrypter, encrypter and macgen modules, and
 pass them the required information, and then will output take their outputs
 and output it to the user
 */
// NEW 
module MTE(clock,key,IN,sel,OUT,valid_key);
  
  input clock;
  input [7:0]key;
  input [7:0]IN;
  input sel;
  output reg valid_key;
  output reg [7:0]OUT;
  
  wire [7:0]R1_out;
  reg [15:0]EnReg;
  reg [15:0] DeReg;
  reg [15:0] OutEn;
  reg [15:0] OutDe;
  reg [7:0]EMAC;
  reg [7:0]DMAC;
  reg EQ;
  reg and_out;
  reg [15:0] out1;
  reg [15:0] OutEn1;
 assign OutEn1 = {OutEn[15:8],OutEn[7:0]}; // Encrpted output(cipher text)
  reg [7:0] OUT1;
  assign EnReg = {IN,EMAC}; // store input and the MAC generated for input in a single reg
  //assign DeReg = {IN,EMAC};
  assign and_out = (~sel & EQ); // and gate from

  macgen M1(clock, key, IN[7:0], 1'b1, EMAC); // Generate MAC for Encryption 
  
  //always @(posedge clock)
   // begin
  //fork
  //  begin
  encryption EN1(clock,key,EnReg[7:0],OutEn[7:0]); // Encrypt MAC part of the input
  encryption EN2(clock,key,EnReg[15:8],OutEn[15:8]); // Encrypt data part of the input
  //  end
   // begin
  decryption DE1(clock,key,OutEn[7:0],OutDe[7:0]); // Decrypting the MAC part of the cypher text 
  decryption DE2(clock,key,OutEn[15:8],OutDe[15:8]); // Decrypting the data part of the cipher text
    //end
  //join
  //  end
  
  macgen M2(clock, key, OutDe[15:8], 1'b1, DMAC); // generate MAC for comparison during decryption
  mac_compare C1(clock, OutEn[7:0], DMAC, EQ);  // compare MAC generated during decrption and the MAC that is decrypted from the cipher text
  assign OUT = OutDe[15:8]; // plain text output
    //Muxnto1 DM
endmodule


/*
// OLD
 module MTE(clock,key,IN,sel,OUT,valid_key);
  parameter N = 8;
  input clock;
  input [N - 1:0]key;
  input [N - 1:0]IN;
  input sel;
  output reg valid_key;
  output reg [N - 1:0]OUT;
  
  //wire [7:0]R1_out;
  reg  [2 * N - 1:0]EnReg;
  reg [2 * N - 1:0] DeReg;
  reg [2 * N - 1:0] OutEn;
  reg [2 * N - 1:0] OutDe;
  reg [N - 1:0]EMAC;
  reg [N - 1:0]DMAC;
  //didn't have EQ and out1 defined, so it wasn't working
  reg EQ;
  reg [N - 1 : 0] out1;

  assign EnReg = {IN,EMAC};
  assign DeReg = {IN,EMAC};

  //needed parameterizing to make it work
  macgen #(.N(N)) M1(clock, key, IN[N - 1:0], 1'b1, EMAC);
  encryption #(.N(N)) EN1(clock,key,DeReg[N - 1:0],OutEn[N - 1:0]); 
  encryption #(.N(N)) EN2(clock,key,DeReg[2 * N - 1: N],OutEn[2 * N - 1:N]); 
 
  decryption #(.N(N)) DE1(clock,key,IN[N - 1:0],OutDe[N - 1:0]); //MAC
  decryption #(.N(N)) DE2(clock,key,IN[N - 1:0],OutDe[2 * N - 1:N]); //cipher text

  macgen #(.N(N)) M2(clock, key, OutDe[2 * N - 1:N], 1'b1, DMAC);
  mac_compare #(.N(N)) C1(clock, OutDe[N - 1:0], DMAC, EQ);
  
 // mac_compare C2(clock, OutDe[255:0], DMAC, EQ);
  Muxnto1 #(.N(N)) DM(out1, '0, OutDe[2 * N - 1:N], EQ);

  Muxnto1 #(.N(N)) FM(OUT, out1, OutEn[2 * N - 1: N], sel);
  //encryption e1(.clock(clock),.key(key),.data(m_data),.e_data(R1_out));
  //decryption e2(.clock(clock),.key(key),.e_data(R1_out),.data(enc_data));
  //decryption e2(clock,key,R1_out,enc_data);
  
endmodule

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
parameter N = 512;
output [N-1:0] Y;
input [N-1:0] V0;
input [N-1:0] V1;
input S;

assign Y = S ? V1 : V0;
endmodule
*/
/*module MTE #(parameter N=512)(clock, key, IN, encrypt, OUT, valid_key);

  input clock;
  input [N-1:0] key;
  input [N-1:0] IN;
  input encrypt;
  output reg [N-1:0] OUT;
  output valid_key;
  
  reg EnReg [N-1:0];
  //string DeReg [];
  reg OutEn [N-1:0];
  reg OutDe [N-1:0];
  reg [N-1:0] EMAC;
  reg [N-1:0] DMAC;
  reg [511:0] data1;
  reg [N-1:0] out1;

  macgen #(.N(N)) M1(clk, key, IN[255:0], 1'b1, EMAC);
// EnReg Array 
  encryption #(.N(N)) EN1(clock,key,EnReg[255:0],OutEn[255:0]);
  encryption #(.N(N)) EN2(clock,key,EnReg[511:256],OutEn[511:256]);
// OutEn Array
  decryption #(.N(N)) DE1(clock,key,IN[255:0],OutDe[255:0]);
  decryption #(.N(N)) DE2(clock,key,IN[511:256],OutDe[511:256]);
// OutDe Array
  macgen #(.N(N)) M1(clk, key, IN[511:256], enable, DMAC);
  mac_compare #(.N(N)) C1(clock, OutDe[255:0], DMAC, EQ);
  Muxnto1 #(.N(N)) #(256)DM(out1, 256'b'0, OutDe[511:256], EQ);

  Muxnto1 #(.N(N)) FM(OUT, out1, OutEn, encrypt);

  assign valid_key = EQ ? 1 : 0;


endmodule*/
