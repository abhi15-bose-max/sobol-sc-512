`timescale 1ns/1ps

`include "../src/config.vh"

module tb_controller;

reg clk;
reg rst;
reg start;

wire load_enable;
wire shift_enable;
wire accumulate_enable;
wire done;

controller uut
(
    .clk(clk),
    .rst(rst),
    .start(start),

    .load_enable(load_enable),
    .shift_enable(shift_enable),
    .accumulate_enable(accumulate_enable),
    .done(done)
);

always #5 clk = ~clk;

integer cycle;

initial
begin

    clk = 0;
    rst = 1;
    start = 0;

    cycle = 0;

    $dumpfile("dump.vcd");
    $dumpvars(0,tb_controller);

    $display("");
    $display("==========================================================================");
    $display("                    CONTROLLER FSM TESTBENCH");
    $display("==========================================================================");
    $display("Cycle     LOAD    SHIFT    ACCUM    DONE");
    $display("--------------------------------------------------------------------------");

    #15;

    rst = 0;

    #10;

    start = 1;

    #10;

    start = 0;

    repeat(`LOAD_CYCLES + `STREAM_LENGTH + 5)
    begin

        @(posedge clk);

        cycle = cycle + 1;

        #1;

        $display("%4d %9b %8b %8b %8b",
            cycle,
            load_enable,
            shift_enable,
            accumulate_enable,
            done);

    end

    $display("--------------------------------------------------------------------------");
    $display("Test Complete.");
    $display("");

    $finish;

end

endmodule
