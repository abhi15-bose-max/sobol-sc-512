`timescale 1ns/1ps

`include "../src/config.vh"

module tb_final_subtractor;

reg [`ACC_WIDTH-1:0] positive_sum;
reg [`ACC_WIDTH-1:0] negative_sum;

wire signed [`ACC_WIDTH:0] signed_result;

final_subtractor uut
(
    .positive_sum(positive_sum),
    .negative_sum(negative_sum),
    .signed_result(signed_result)
);

initial
begin

    $dumpfile("dump.vcd");
    $dumpvars(0, tb_final_subtractor);

    $display("");
    $display("==============================================================");
    $display("               FINAL SUBTRACTOR TESTBENCH");
    $display("==============================================================");
    $display(" Positive Sum    Negative Sum      Signed Result");
    $display("--------------------------------------------------------------");

    positive_sum = 100;
    negative_sum = 25;
    #1;
    $display("%10d %15d %18d",
        positive_sum, negative_sum, signed_result);

    positive_sum = 20;
    negative_sum = 80;
    #1;
    $display("%10d %15d %18d",
        positive_sum, negative_sum, signed_result);

    positive_sum = 512;
    negative_sum = 512;
    #1;
    $display("%10d %15d %18d",
        positive_sum, negative_sum, signed_result);

    positive_sum = 0;
    negative_sum = 512;
    #1;
    $display("%10d %15d %18d",
        positive_sum, negative_sum, signed_result);

    positive_sum = 1024;
    negative_sum = 256;
    #1;
    $display("%10d %15d %18d",
        positive_sum, negative_sum, signed_result);

    $display("--------------------------------------------------------------");
    $display("Test Complete.");
    $display("");

    $finish;

end

endmodule
