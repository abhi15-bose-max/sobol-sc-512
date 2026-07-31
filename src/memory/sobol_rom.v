/*
------------------------------------------------------------------------------
File        : sobol_rom.v

Description :
Dual-read Sobol ROM.

Each ROM stores the complete Sobol bitstream library.

Each address corresponds to one complete stochastic stream.

Address 0   -> 0.00_A
Address 1   -> 0.00_B
Address 2   -> 0.01_A
...
Address 201 -> 1.00_B

The ROM provides two independent read ports so that one pair of
stochastic streams can be loaded every clock cycle.

Multiple ROM instances may be instantiated in top.v to reduce
initialisation latency.

------------------------------------------------------------------------------
*/

`include "config.vh"

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
