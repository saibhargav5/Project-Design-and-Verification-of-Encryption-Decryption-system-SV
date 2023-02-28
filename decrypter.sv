/*this module will take the 32 bytes of encrypted data and the key (on clock edges)
 it will do some operation on the data to decrypt it (using the key and reversing 
 the encryption formula) and then will output that unencrypted 32 bytes.
 */

module decrypter (input clk, [7:0]key, [255:0]e_data,
            output [255:0] data);