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
    $dumpvars(0,tb_sc_multiplier);

    a_bit = 0; b_bit = 0;
    #10;

    a_bit = 0; b_bit = 1;
    #10;

    a_bit = 1; b_bit = 0;
    #10;

    a_bit = 1; b_bit = 1;
    #10;

    $finish;

end

endmodule
