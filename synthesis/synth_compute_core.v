/*
------------------------------------------------------------------------------
File        : synth_compute_core.v

Description :
Structural synthesis wrapper for the stochastic compute core.

Architecture :

    128 Multipliers
            │
            ▼
    128 Sign Routers
            │
            ▼
    Positive Popcount
    Negative Popcount
            │
            ▼
    Positive Accumulator
    Negative Accumulator
            │
            ▼
      Final Subtractor

Purpose :
    - Instantiate the complete compute datapath
    - Prevent optimization by exposing the final result
    - Used only for synthesis/resource estimation

------------------------------------------------------------------------------
*/

`include "../src/config.vh"

module synth_compute_core
(
    input  wire                         clk,
    input  wire                         rst,
    input  wire                         enable,

    input  wire [`DOT_PRODUCT_SIZE-1:0] operand_a,
    input  wire [`DOT_PRODUCT_SIZE-1:0] operand_b,

    input  wire [`DOT_PRODUCT_SIZE-1:0] sign_a,
    input  wire [`DOT_PRODUCT_SIZE-1:0] sign_b,

    output wire signed [`ACC_WIDTH:0] result
);

localparam NUM_MACS = `DOT_PRODUCT_SIZE;

genvar i;

// -----------------------------------------------------------------------------
// Internal Signals
// -----------------------------------------------------------------------------

wire [NUM_MACS-1:0] product_bits;
wire [NUM_MACS-1:0] positive_bits;
wire [NUM_MACS-1:0] negative_bits;

wire [`POPCOUNT_WIDTH-1:0] positive_count;
wire [`POPCOUNT_WIDTH-1:0] negative_count;

wire [`ACC_WIDTH-1:0] positive_sum;
wire [`ACC_WIDTH-1:0] negative_sum;

// -----------------------------------------------------------------------------
// Multiplier Array
// -----------------------------------------------------------------------------

generate

    for(i = 0; i < NUM_MACS; i = i + 1)
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
// Sign Router Array
// -----------------------------------------------------------------------------

generate

    for(i = 0; i < NUM_MACS; i = i + 1)
    begin : ROUTER_ARRAY

        sign_router router_inst
        (
            .product_bit  (product_bits[i]),

            .sign_a       (sign_a[i]),
            .sign_b       (sign_b[i]),

            .positive_bit (positive_bits[i]),
            .negative_bit (negative_bits[i])
        );

    end

endgenerate

// -----------------------------------------------------------------------------
// Positive Popcount
// -----------------------------------------------------------------------------

popcount positive_popcount
(
    .bits  (positive_bits),
    .count (positive_count)
);

// -----------------------------------------------------------------------------
// Negative Popcount
// -----------------------------------------------------------------------------

popcount negative_popcount
(
    .bits  (negative_bits),
    .count (negative_count)
);

// -----------------------------------------------------------------------------
// Positive Accumulator
// -----------------------------------------------------------------------------

positive_accumulator positive_accumulator_inst
(
    .clk             (clk),
    .rst             (rst),
    .enable          (enable),

    .count           (positive_count),
    .accumulated_sum (positive_sum)
);

// -----------------------------------------------------------------------------
// Negative Accumulator
// -----------------------------------------------------------------------------

negative_accumulator negative_accumulator_inst
(
    .clk             (clk),
    .rst             (rst),
    .enable          (enable),

    .count           (negative_count),
    .accumulated_sum (negative_sum)
);

// -----------------------------------------------------------------------------
// Final Subtractor
// -----------------------------------------------------------------------------

final_subtractor final_subtractor_inst
(
    .positive_sum (positive_sum),
    .negative_sum (negative_sum),

    .signed_result(result)
);

endmodule
