/*
------------------------------------------------------------------------------
File        : datapath.v

Description :
Compute datapath for the Sobol stochastic MAC.

The datapath receives one stochastic bit from each operand pair every clock
cycle and computes the signed stochastic accumulation.

Memory loading is handled by loader.v.

------------------------------------------------------------------------------
*/

`include "config.vh"

module datapath
(
    input wire clk,
    input wire rst,

    input wire accumulate_enable,

    input wire [`DOT_PRODUCT_SIZE-1:0] operand_a_bits,
    input wire [`DOT_PRODUCT_SIZE-1:0] operand_b_bits,

    input wire [`DOT_PRODUCT_SIZE-1:0] sign_a,
    input wire [`DOT_PRODUCT_SIZE-1:0] sign_b,

    output wire signed [`ACC_WIDTH:0] result
);

// -----------------------------------------------------------------------------
// Internal Signals
// -----------------------------------------------------------------------------

wire [`DOT_PRODUCT_SIZE-1:0] product_bits;
wire [`DOT_PRODUCT_SIZE-1:0] positive_bits;
wire [`DOT_PRODUCT_SIZE-1:0] negative_bits;

wire [`POPCOUNT_WIDTH-1:0] positive_count;
wire [`POPCOUNT_WIDTH-1:0] negative_count;

wire [`ACC_WIDTH-1:0] positive_sum;
wire [`ACC_WIDTH-1:0] negative_sum;

// -----------------------------------------------------------------------------
// Parallel Stochastic Multipliers
// -----------------------------------------------------------------------------

genvar i;

generate
for(i=0; i<`DOT_PRODUCT_SIZE; i=i+1)
begin : MULTIPLIERS

    sc_multiplier mult
    (
        .a_bit(operand_a_bits[i]),
        .b_bit(operand_b_bits[i]),
        .product_bit(product_bits[i])
    );

end
endgenerate

// -----------------------------------------------------------------------------
// Sign Routers
// -----------------------------------------------------------------------------

generate
for(i=0; i<`DOT_PRODUCT_SIZE; i=i+1)
begin : SIGN_ROUTERS

    sign_router router
    (
        .product_bit(product_bits[i]),
        .sign_a(sign_a[i]),
        .sign_b(sign_b[i]),
        .positive_bit(positive_bits[i]),
        .negative_bit(negative_bits[i])
    );

end
endgenerate

// -----------------------------------------------------------------------------
// Popcount Units
// -----------------------------------------------------------------------------

popcount positive_popcount
(
    .bits(positive_bits),
    .count(positive_count)
);

popcount negative_popcount
(
    .bits(negative_bits),
    .count(negative_count)
);

// -----------------------------------------------------------------------------
// Accumulators
// -----------------------------------------------------------------------------

positive_accumulator positive_acc
(
    .clk(clk),
    .rst(rst),
    .enable(accumulate_enable),
    .count(positive_count),
    .accumulated_sum(positive_sum)
);

negative_accumulator negative_acc
(
    .clk(clk),
    .rst(rst),
    .enable(accumulate_enable),
    .count(negative_count),
    .accumulated_sum(negative_sum)
);

// -----------------------------------------------------------------------------
// Final Subtractor
// -----------------------------------------------------------------------------

final_subtractor subtractor
(
    .positive_sum(positive_sum),
    .negative_sum(negative_sum),
    .signed_result(result)
);

endmodule
