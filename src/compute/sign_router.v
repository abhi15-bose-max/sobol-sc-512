/*
------------------------------------------------------------------------------
File        : sign_router.v

Description :
Routes the stochastic product bit into either the positive or negative
accumulator path.

The XOR of the operand signs determines the sign of the product.

sign = 0 -> positive

sign = 1 -> negative

------------------------------------------------------------------------------
*/

module sign_router
(
    input wire product_bit,

    input wire sign_a,
    input wire sign_b,

    output wire positive_bit,
    output wire negative_bit
);

wire product_sign;

assign product_sign = sign_a ^ sign_b;

assign positive_bit = (~product_sign) & product_bit;

assign negative_bit = product_sign & product_bit;

endmodule
