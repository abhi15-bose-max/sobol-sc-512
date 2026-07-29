`timescale 1ns/1ps

`include "../src/config.vh"

module tb_popcount;

reg [`DOT_PRODUCT_SIZE-1:0] bits;

wire [`POPCOUNT_WIDTH-1:0] count;

popcount uut
(
    .bits(bits),
    .count(count)
);

initial begin

    $dumpfile("dump.vcd");
    $dumpvars(0,tb_popcount);

    bits = 0;
    #10;

    bits = {`DOT_PRODUCT_SIZE{1'b1}};
    #10;

    bits = 0;
    bits[0] = 1;
    bits[5] = 1;
    bits[10] = 1;
    bits[50] = 1;
    #10;

    $finish;

end

endmodule
