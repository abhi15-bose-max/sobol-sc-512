/*
------------------------------------------------------------------------------
File        : synth_128_multipliers.v

Description :
Structural synthesis wrapper for stochastic multipliers.

Purpose :
    - Instantiate 128 stochastic multipliers
    - Prevent optimization by exposing multiplier outputs
    - Used only for synthesis/resource estimation

------------------------------------------------------------------------------
*/

`include "../src/config.vh"

module synth_128_multipliers
(
    input  wire [`DOT_PRODUCT_SIZE-1:0] operand_a,
    input  wire [`DOT_PRODUCT_SIZE-1:0] operand_b,

    output wire debug
);

localparam NUM_MULTIPLIERS = `DOT_PRODUCT_SIZE;

genvar i;

// -----------------------------------------------------------------------------
// Multiplier Outputs
// -----------------------------------------------------------------------------

wire [NUM_MULTIPLIERS-1:0] product_bits;

// -----------------------------------------------------------------------------
// Multiplier Array
// -----------------------------------------------------------------------------

generate

    for (i = 0; i < NUM_MULTIPLIERS; i = i + 1)
    begin : MULTIPLIER_ARRAY

        sc_multiplier multiplier_inst
        (
            .a_bit       (operand_a[i]),
            .b_bit       (operand_b[i]),
            .product_bit (product_bits[i])
        );

    end

endgenerate

// -----------------------------------------------------------------------------
// Prevent Optimization
// -----------------------------------------------------------------------------

assign debug = ^product_bits;

endmodule
