/*
------------------------------------------------------------------------------
File        : final_subtractor.v

Description :
Computes the final signed stochastic result by subtracting the accumulated
negative count from the accumulated positive count.

Result = Positive Sum - Negative Sum

------------------------------------------------------------------------------
*/

`include "config.vh"

module final_subtractor
(
    input wire [`ACC_WIDTH-1:0] positive_sum,
    input wire [`ACC_WIDTH-1:0] negative_sum,

    output wire signed [`ACC_WIDTH:0] signed_result
);

assign signed_result =
    $signed({1'b0, positive_sum}) -
    $signed({1'b0, negative_sum});

endmodule
