/*
------------------------------------------------------------------------------
File        : synth_128_sign_routers.v

Description :
Structural synthesis wrapper for sign routers.

Purpose :
    - Instantiate 128 sign routers
    - Prevent optimization by exposing router outputs
    - Used only for synthesis/resource estimation

------------------------------------------------------------------------------
*/

`include "../src/config.vh"

module synth_128_sign_routers
(
    input  wire [`DOT_PRODUCT_SIZE-1:0] product_bits,

    input  wire [`DOT_PRODUCT_SIZE-1:0] sign_a,
    input  wire [`DOT_PRODUCT_SIZE-1:0] sign_b,

    output wire debug
);

localparam NUM_ROUTERS = `DOT_PRODUCT_SIZE;

genvar i;

// -----------------------------------------------------------------------------
// Router Outputs
// -----------------------------------------------------------------------------

wire [NUM_ROUTERS-1:0] positive_bits;
wire [NUM_ROUTERS-1:0] negative_bits;

// -----------------------------------------------------------------------------
// Router Array
// -----------------------------------------------------------------------------

generate

    for (i = 0; i < NUM_ROUTERS; i = i + 1)
    begin : ROUTER_ARRAY

        sign_router router_inst
        (
            .product_bit (product_bits[i]),

            .sign_a      (sign_a[i]),
            .sign_b      (sign_b[i]),

            .positive_bit(positive_bits[i]),
            .negative_bit(negative_bits[i])
        );

    end

endgenerate

// -----------------------------------------------------------------------------
// Prevent Optimization
// -----------------------------------------------------------------------------

assign debug = ^positive_bits ^ ^negative_bits;

endmodule
