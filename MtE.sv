/*this module will take the 32 bytes of data and the key (on clock edges)
 it will instantiatee the decrypter, encrypter and macgen modules, and
 pass them the required information, and then will output take their outputs
 and output it to the user
 */
 
module decrypter (input clk, [7:0]key, [255:0]e_data, encrypt,
            output [7:0]MAC, [255:0] data, valid_key);