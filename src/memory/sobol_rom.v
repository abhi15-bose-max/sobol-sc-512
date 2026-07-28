/*
------------------------------------------------------------------------------
File        : sobol_rom.v

Description :
Dual-read Sobol ROM.

This module stores all pre-generated Sobol stochastic bitstreams.
Each address corresponds to one complete stochastic stream.

Example:

Address 0   -> 0.00 (Stream A)
Address 1   -> 0.00 (Stream B)
Address 2   -> 0.01 (Stream A)
...
Address 201 -> 1.00 (Stream B)

Two independent read ports allow both operand streams of a MAC
to be loaded simultaneously.

The ROM contents are initialized from:

library/sobol.mem

------------------------------------------------------------------------------
*/

`include "../config.vh"

module sobol_rom
(
    input  wire [`ROM_ADDR_WIDTH-1:0] address_a,
    input  wire [`ROM_ADDR_WIDTH-1:0] address_b,

    output wire [`STREAM_LENGTH-1:0] stream_a,
    output wire [`STREAM_LENGTH-1:0] stream_b
);

reg [`STREAM_LENGTH-1:0] rom [0:`NUM_STREAMS-1];

initial begin
    $readmemb("library/sobol.mem", rom);
end

assign stream_a = rom[address_a];
assign stream_b = rom[address_b];

endmodule
