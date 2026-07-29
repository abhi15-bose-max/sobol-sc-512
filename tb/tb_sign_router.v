`timescale 1ns/1ps

module tb_sign_router;

reg product_bit;

reg sign_a;
reg sign_b;

wire positive_bit;
wire negative_bit;

sign_router uut
(
    .product_bit(product_bit),
    .sign_a(sign_a),
    .sign_b(sign_b),
    .positive_bit(positive_bit),
    .negative_bit(negative_bit)
);

initial begin

    $dumpfile("dump.vcd");
    $dumpvars(0,tb_sign_router);

    product_bit = 1;

    sign_a = 0; sign_b = 0; #10;
    sign_a = 0; sign_b = 1; #10;
    sign_a = 1; sign_b = 0; #10;
    sign_a = 1; sign_b = 1; #10;

    $finish;

end

endmodule
