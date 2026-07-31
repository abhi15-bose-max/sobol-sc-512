/*
------------------------------------------------------------------------------
File        : negative_accumulator.v

Description :
Accumulates the negative popcount values over the entire stochastic stream.

------------------------------------------------------------------------------
*/

`include "config.vh"

module negative_accumulator
(
    input  wire                         clk,
    input  wire                         rst,
    input  wire                         enable,

    input  wire [`POPCOUNT_WIDTH-1:0]   count,

    output reg  [`ACC_WIDTH-1:0]        accumulated_sum
);

always @(posedge clk)
begin

    if (rst)
        accumulated_sum <= 0;

    else if (enable)
        accumulated_sum <= accumulated_sum +
                   {{(`ACC_WIDTH-`POPCOUNT_WIDTH){1'b0}}, count};

end

endmodule
