`timescale 1ns / 1ps
`include "config.vh"

module pnr_compute_core
(
    input  wire clk,
    input  wire reset,

    output wire debug
);

    //------------------------------------------------------------
    // Internal stimulus
    //------------------------------------------------------------

    reg [`DOT_PRODUCT_SIZE-1:0] operand_a = 0;
    reg [`DOT_PRODUCT_SIZE-1:0] operand_b = 1;

    reg [`DOT_PRODUCT_SIZE-1:0] sign_a = 0;
    reg [`DOT_PRODUCT_SIZE-1:0] sign_b = 0;

    wire signed [`ACC_WIDTH:0] result;

    //------------------------------------------------------------
    // Generate activity
    //------------------------------------------------------------

    always @(posedge clk)
    begin
        if (reset)
        begin
            operand_a <= 0;
            operand_b <= 1;

            sign_a <= 0;
            sign_b <= 0;
        end
        else
        begin
            operand_a <= operand_a + 1'b1;
            operand_b <= operand_b + 2'b10;

            sign_a <= operand_a;
            sign_b <= operand_b;
        end
    end

    //------------------------------------------------------------
    // Compute Core
    //------------------------------------------------------------

    synth_compute_core compute_core
    (
        .clk(clk),
        .rst(reset),
        .enable(1'b1),

        .operand_a(operand_a),
        .operand_b(operand_b),

        .sign_a(sign_a),
        .sign_b(sign_b),

        .result(result)
    );

    //------------------------------------------------------------
    // Prevent optimisation
    //------------------------------------------------------------

    assign debug = ^result;

endmodule
