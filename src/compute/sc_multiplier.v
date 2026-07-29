/*
------------------------------------------------------------------------------
File        : sc_multiplier.v

Description :
Stochastic multiplier.

Performs stochastic multiplication using a single AND gate.

Inputs:
    a_bit
    b_bit

Output:
    product_bit

------------------------------------------------------------------------------
*/

module sc_multiplier
(
    input  wire a_bit,
    input  wire b_bit,

    output wire product_bit
);

assign product_bit = a_bit & b_bit;

endmodule
