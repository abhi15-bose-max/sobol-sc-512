`timescale 1ns/1ps

module tb_sc_multiplier;

reg a_bit;
reg b_bit;

wire product_bit;

sc_multiplier uut
(
    .a_bit(a_bit),
    .b_bit(b_bit),
    .product_bit(product_bit)
);

initial begin

    $dumpfile("dump.vcd");
    $dumpvars(0, tb_sc_multiplier);

    $display("");
    $display("==============================================");
    $display("      STOCHASTIC MULTIPLIER TESTBENCH");
    $display("==============================================");
    $display(" a_bit   b_bit   |   product_bit");
    $display("----------------------------------------------");

    a_bit = 0; b_bit = 0; #1;
    $display("   %b       %b     |        %b", a_bit, b_bit, product_bit);

    a_bit = 0; b_bit = 1; #1;
    $display("   %b       %b     |        %b", a_bit, b_bit, product_bit);

    a_bit = 1; b_bit = 0; #1;
    $display("   %b       %b     |        %b", a_bit, b_bit, product_bit);

    a_bit = 1; b_bit = 1; #1;
    $display("   %b       %b     |        %b", a_bit, b_bit, product_bit);

    $display("----------------------------------------------");
    $display("Test Complete.");
    $display("");

    $finish;

end

endmodule
