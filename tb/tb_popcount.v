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
    $dumpvars(0, tb_popcount);

    $display("");
    $display("===================================================");
    $display("               POPCOUNT TESTBENCH");
    $display("===================================================");
    $display(" Case                        Count");
    $display("---------------------------------------------------");

    bits = 0;
    #1;
    $display(" All zeros               -> %0d", count);

    bits = {`DOT_PRODUCT_SIZE{1'b1}};
    #1;
    $display(" All ones                -> %0d", count);

    bits = 0;
    bits[0]   = 1;
    bits[5]   = 1;
    bits[10]  = 1;
    bits[50]  = 1;
    #1;
    $display(" Four asserted bits      -> %0d", count);

    bits = 0;
    bits[2]   = 1;
    bits[4]   = 1;
    bits[6]   = 1;
    bits[8]   = 1;
    bits[10]  = 1;
    bits[12]  = 1;
    bits[14]  = 1;
    bits[16]  = 1;
    #1;
    $display(" Eight asserted bits     -> %0d", count);

    $display("---------------------------------------------------");
    $display("Test Complete.");
    $display("");

    $finish;

end

endmodule
