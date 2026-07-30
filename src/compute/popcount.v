/*
------------------------------------------------------------------------------
File        : popcount.v

Description :
Counts the number of asserted stochastic bits produced by all MAC units
during one clock cycle.

The input width equals the number of MAC units.

------------------------------------------------------------------------------
*/

`include "config.vh"

module popcount
(
    input wire [`DOT_PRODUCT_SIZE-1:0] bits,

    output reg [`POPCOUNT_WIDTH-1:0] count
);

integer i;

always @(*) begin

    count = 0;

    for(i = 0; i < `DOT_PRODUCT_SIZE; i = i + 1)
    begin
        count = count + bits[i];
    end

end

endmodule
