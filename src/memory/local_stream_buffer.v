/*
------------------------------------------------------------------------------
File        : local_stream_buffer.v

Description :
Local storage for one Sobol stochastic bitstream.

Operation

LOAD
    Loads one complete stochastic stream from the Sobol ROM.

SHIFT
    Outputs one stochastic bit every clock cycle.

Each operand owns one Local Stream Buffer.

Therefore,

Number of Buffers = 2 × DOT_PRODUCT_SIZE

During initialisation the buffers are loaded from one of the ROM banks.

During computation the ROM is no longer accessed.

------------------------------------------------------------------------------
*/

`include "config.vh"

module local_stream_buffer
(
    input wire clk,
    input wire reset,

    input wire load,
    input wire shift,

    input wire [`STREAM_LENGTH-1:0] stream_in,

    output wire bit_out
);

reg [`STREAM_LENGTH-1:0] buffer;

always @(posedge clk)
begin

    if (reset)
    begin
        buffer <= 0;
    end

    else if (load)
    begin
        buffer <= stream_in;
    end

    else if (shift)
    begin
        buffer <= {buffer[`STREAM_LENGTH-2:0], 1'b0};
    end

end

// Stream MSB first
assign bit_out = buffer[`STREAM_LENGTH-1];

endmodule
