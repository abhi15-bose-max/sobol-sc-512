`timescale 1ns/1ps

`include "../src/config.vh"

module tb_positive_accumulator;

reg clk;
reg rst;
reg enable;

reg  [`POPCOUNT_WIDTH-1:0] count;

wire [`ACC_WIDTH-1:0] accumulated_sum;

positive_accumulator uut
(
    .clk(clk),
    .rst(rst),
    .enable(enable),
    .count(count),
    .accumulated_sum(accumulated_sum)
);

always #5 clk = ~clk;

integer cycle;

initial
begin

    clk = 0;
    rst = 1;
    enable = 0;
    count = 0;
    cycle = 0;

    $dumpfile("dump.vcd");
    $dumpvars(0,tb_positive_accumulator);

    $display("");
    $display("==============================================================");
    $display("            POSITIVE ACCUMULATOR TESTBENCH");
    $display("==============================================================");
    $display("Cycle     Input Count     Accumulated Sum");
    $display("--------------------------------------------------------------");

    #10;

    rst = 0;
    enable = 1;

    count = 12;
    @(posedge clk);
    cycle = cycle + 1;
    #1;
    $display("%3d %15d %18d", cycle, count, accumulated_sum);

    count = 8;
    @(posedge clk);
    cycle = cycle + 1;
    #1;
    $display("%3d %15d %18d", cycle, count, accumulated_sum);

    count = 15;
    @(posedge clk);
    cycle = cycle + 1;
    #1;
    $display("%3d %15d %18d", cycle, count, accumulated_sum);

    count = 2;
    @(posedge clk);
    cycle = cycle + 1;
    #1;
    $display("%3d %15d %18d", cycle, count, accumulated_sum);

    count = 0;
    @(posedge clk);
    cycle = cycle + 1;
    #1;
    $display("%3d %15d %18d", cycle, count, accumulated_sum);

    $display("--------------------------------------------------------------");
    $display("Test Complete.");
    $display("");

    $finish;

end

endmodule
