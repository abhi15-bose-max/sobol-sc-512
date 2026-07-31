`timescale 1ns / 1ps
`include "config.vh"

module pnr_compute_core (

    input  wire clk,
    input  wire reset,

    output wire debug

);

    //------------------------------------------------------------
    // Internal stimulus registers
    //------------------------------------------------------------

    reg [`NUM_STREAMS-1:0] operand_a;
    reg [`NUM_STREAMS-1:0] operand_b;

    reg [`NUM_STREAMS-1:0] sign_a;
    reg [`NUM_STREAMS-1:0] sign_b;

    wire signed [`ACC_WIDTH-1:0] result;

    //------------------------------------------------------------
    // Simple stimulus generation
    //------------------------------------------------------------

    always @(posedge clk) begin

        if (reset) begin

            operand_a <= 0;
            operand_b <= 1;

            sign_a <= 0;
            sign_b <= {`NUM_STREAMS{1'b1}};

        end
        else begin

            operand_a <= operand_a + 1'b1;
            operand_b <= operand_b + 2'b10;

            sign_a <= operand_a;
            sign_b <= operand_b;

        end

    end

    //------------------------------------------------------------
    // Compute Core
    //------------------------------------------------------------

    synth_compute_core compute_core (

        .operand_a(operand_a),
        .operand_b(operand_b),

        .sign_a(sign_a),
        .sign_b(sign_b),

        .clk(clk),
        .reset(reset),

        .result(result)

    );

    //------------------------------------------------------------
    // Prevent optimisation
    //------------------------------------------------------------

    assign debug = ^result;

endmodule
