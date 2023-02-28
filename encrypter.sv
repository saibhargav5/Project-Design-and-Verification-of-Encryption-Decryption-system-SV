/*this module will take the 32 bytes of data and the key (on clock edges)
 it will do some operation on the data to encrypt it (using the key somehow)
 and then will output that encrypted 32 bytes.
 */

module encrypter(input clk, [7:0]key, [255:0]data,
            output [255:0]e_data);