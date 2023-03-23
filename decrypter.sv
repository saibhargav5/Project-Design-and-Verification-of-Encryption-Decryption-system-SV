 /*this module will take the 32 bytes of encrypted data and the key (on clock edges)
 it will do some operation on the data to decrypt it (using the key and reversing 
 the encryption formula) and then will output that unencrypted 32 bytes.
 */

module decryption #(parameter N=8)(clock,key,e_data,data);
 input clock;
 input [N-1:0] key;
 input [N-1:0] e_data;
 output reg [N-1:0] data;
  
  reg [N-1:0] out1,out2,out3, out4,out51,out5;

typedef struct packed {
  logic [N-1:0] e_data; //input
  logic [N-1:0] data;   //output
}stage1;

typedef struct packed {
  logic [N-1:0] key;
  logic [N-1:0] data; 
}stage2;

stage1 S1;
stage2 S2,S3,S4,S5;
  
  //needed to rename the modules because they were defined with the same names as the encrypter, so I added _d for decrypter
  //needed to add parameterization to the code
  rotateleft_d #(.N(N))  X2(out1,e_data);
  reverse_d #(.N(N)) n4(out2,S1.data); 
  NOT_d #(.N(N)) n3(out3,S2.data);
  rotateright_d #(.N(N)) n5(out4,S3.data);
  XOR_d #(.N(N)) x1(out5,S5.key,S4.data);
  
  
  assign data = S5.data;
  
 // assign e_MAC = R10;
  
always @(posedge clock)
  begin
   S2.key <= key;
   S3.key <= S2.key;
   S4.key <= S3.key;
   S5.key <= S4.key;
   S1.e_data <= e_data;
   S1.data <= out1;
    
   S2.data <= out2;
   S3.data <= out3;
   S4.data <= out4;
   S5.data <= out5;
  end
  
endmodule
module XOR_d #(parameter N=8)(output [N-1:0]out,input [N-1:0]key,data);
  
  assign out = (key ^ data);
  //initial $monitor("out=%d key=%d data=%d",out,key,data);
endmodule


module rotateleft_d #(parameter N=8) (output [N-1:0]out, input [N-1:0]data);
  assign out = {data[N/2-1:0],data[N-1:N/2]};
  //initial $monitor("out=%d data=%d",out,data);
endmodule

module NOT_d #(parameter N=8) (output [N-1:0]out, input [N-1:0]data);
 assign out = ~data;
 // initial $monitor("out=%d data=%d",out,data);
endmodule

module reverse_d #(parameter N=8) (output reg [N-1:0]out, input [N-1:0]data);
  
  always @(data)
    begin
      for (int i = 0; i < N; i = i + 1)
       out[i] = data[N-i-1];     
    end
  //assign out4 = {data[0],data[1],data[2],data[3],data[4],data[5],data[6],data[7]};
endmodule

module rotateright_d #(parameter N=8) (output [N-1:0]out, input [N-1:0]data);
  assign out = {data[N/2-1:0],data[N-1:N/2]};
  //initial $monitor("out=%d data=%d",out,data);
endmodule

