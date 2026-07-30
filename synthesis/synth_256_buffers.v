/*
------------------------------------------------------------------------------
File        : synth_256_buffers.v

Description :
Structural synthesis wrapper for Local Stream Buffers.

Purpose :
    - Instantiate one Local Stream Buffer per operand
    - Prevent optimization by exposing buffer outputs
    - Used only for synthesis/resource estimation

------------------------------------------------------------------------------
*/

`include "../src/config.vh"

module synth_256_buffers
(
    input  wire clk,
    input  wire reset,

    output wire debug
);

localparam NUM_BUFFERS = 2 * `DOT_PRODUCT_SIZE;

genvar i;

// -----------------------------------------------------------------------------
// Buffer Outputs
// -----------------------------------------------------------------------------

wire [NUM_BUFFERS-1:0] bit_out;

// -----------------------------------------------------------------------------
// Buffer Array
// -----------------------------------------------------------------------------

generate

    for (i = 0; i < NUM_BUFFERS; i = i + 1)
    begin : BUFFER_ARRAY

        local_stream_buffer buffer_inst
        (
            .clk      (clk),
            .reset    (reset),

            .load     (1'b1),
            .shift    (1'b0),

            .stream_in({`STREAM_LENGTH{i[0]}}),

            .bit_out  (bit_out[i])
        );

    end

endgenerate

// -----------------------------------------------------------------------------
// Prevent Optimization
// -----------------------------------------------------------------------------

assign debug = ^bit_out;

endmodule
