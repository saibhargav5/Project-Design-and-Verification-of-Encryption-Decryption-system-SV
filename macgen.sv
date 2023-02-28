/*this will take in some data and then do some operation on it (on clock edges)
 it will take each chunk (32 bytes) of data and do some operation on it 
 and the key, and combine the result with the result from the last chunk of data's 
 result at the end this will have have a MAC that used the data from every chunk that
 we have read.
 */
 
module macgen(input clk, [7:0]key, [255:0]data,
            output [7:0] MAC);