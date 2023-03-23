  /*this module will take the 32 bytes of data and the key (on clock edges)
 it will do some operation on the data to encrypt it (using the key somehow)
 and then will output that encrypted 32 bytes.
 */
/*   ENCRYPT 
1) xor with key etc    
2) left shift(5)     
3) not               
4) reverse             => reverse (eg: [abcdefgh] -> [hgfedcba]) 
5) right shift(5)      
*/

// Code your design here
module encryption #(parameter N=8)(clock,key,data,e_data);
  input clock;
  input [N-1:0] key;
  input [N-1:0] data;
  //input [7:0] MAC;
  output reg [N-1:0] e_data;
  //output reg [7:0] e_MAC;
  
  //reg [7:0]R1,R2,R3,R4,R5,R6,R7,R8,R9,R10; 
  reg [N-1:0] out1,out2,out3,out4,out5;

typedef struct packed {
  logic [N-1:0] key;
  logic [N-1:0] data;
  logic [N-1:0] e_data;
}stage1;

typedef struct packed {
  logic [N-1:0] e_data;
}stage2;

stage1 S1;
stage2 S2,S3,S4,S5;
  
  //needed parameterizing to make it work 
  XOR #(.N(N)) x1(out1,key,data);
  rotateleft #(.N(N)) X2(out2,S1.e_data);
  NOT #(.N(N)) n3(out3,S2.e_data);
  reverse #(.N(N)) n4(out4,S3.e_data);
  rotateright #(.N(N)) n5(out5,S4.e_data);
  
  
  assign e_data = S5.e_data;
 // assign e_MAC = R10;
  
always @(posedge clock)
  begin
   S1.key <= key;
   S1.data <= data;
   S1.e_data <= out1;
    
   S2.e_data <= out2;
   S3.e_data <= out3;
   S4.e_data <= out4;
   S5.e_data <= out5;
   //$display("Output: %b", e_data);
  end
  
endmodule


module XOR #(parameter N=8)(output [N-1:0]out1,input [N-1:0]key,data);
  
  assign out1 = key ^ data;
  //initial $monitor("out1=%d key=%d data=%d",out1,key,data);
	//$display("input: %b\tout1: %b\n", data, out1);
endmodule


module rotateleft #(parameter N=8) (output [N-1:0]out2, input [N-1:0]data);
  assign out2 = {data[N/2-1:0],data[N-1:N/2]};
  //initial $monitor("out2=%d data=%d",out2,data);
endmodule

module NOT #(parameter N=8) (output [N-1:0]out3, input [N-1:0]data);
 assign out3 = ~data;
 // initial $monitor("out3=%d data=%d",out3,data);
endmodule

module reverse #(parameter N=8) (output reg [N-1:0]out4, input [N-1:0]data);
  
  always @(data)
    begin
      for (int i = 0; i < N; i = i + 1)
       out4[i] = data[N-i-1];     
    end
  //assign out4 = {data[0],data[1],data[2],data[3],data[4],data[5],data[6],data[7]};
endmodule
  
module rotateright #(parameter N=8) (output [N-1:0]out5, input [N-1:0]data);
  assign out5 = {data[N/2-1:0],data[N-1:N/2]};
  //initial $monitor("out5=%d data=%d", out5, data);
endmodule 
