/*
------------------------------------------------------------------------------
File        : positive_accumulator.v

Description :
Accumulates the positive popcount values over the entire stochastic stream.

Operation:

    accumulated_sum <= accumulated_sum + count

One accumulation occurs every clock cycle while 'enable' is asserted.

------------------------------------------------------------------------------
*/

`include "config.vh"

module positive_accumulator
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
        accumulated_sum <= accumulated_sum + count;

end

endmodule
