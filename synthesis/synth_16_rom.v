/*
------------------------------------------------------------------------------
File        : synth_16_rom.v

Description :
Structural synthesis wrapper for sixteen Sobol ROM instances.

Purpose:
    - Instantiate 16 Sobol ROMs
    - Prevent optimization by exposing ROM outputs
    - Used only for synthesis/resource estimation

------------------------------------------------------------------------------
*/

`include "../src/config.vh"

module synth_16_rom
(
    output wire debug
);

localparam NUM_ROMS = 16;

genvar i;

wire [`STREAM_LENGTH-1:0] stream_a [0:NUM_ROMS-1];
wire [`STREAM_LENGTH-1:0] stream_b [0:NUM_ROMS-1];

generate

for(i=0; i<NUM_ROMS; i=i+1)
begin : ROM_ARRAY

    sobol_rom rom_inst
    (
        .address_a(i),
        .address_b(i+1),

        .stream_a(stream_a[i]),
        .stream_b(stream_b[i])
    );

end

endgenerate


//---------------------------------------------------------
// Prevent optimization
//---------------------------------------------------------

wire [`STREAM_LENGTH-1:0] debug_bus;

assign debug_bus =
      stream_a[0]
    ^ stream_b[0]
    ^ stream_a[1]
    ^ stream_b[1]
    ^ stream_a[2]
    ^ stream_b[2]
    ^ stream_a[3]
    ^ stream_b[3]
    ^ stream_a[4]
    ^ stream_b[4]
    ^ stream_a[5]
    ^ stream_b[5]
    ^ stream_a[6]
    ^ stream_b[6]
    ^ stream_a[7]
    ^ stream_b[7]
    ^ stream_a[8]
    ^ stream_b[8]
    ^ stream_a[9]
    ^ stream_b[9]
    ^ stream_a[10]
    ^ stream_b[10]
    ^ stream_a[11]
    ^ stream_b[11]
    ^ stream_a[12]
    ^ stream_b[12]
    ^ stream_a[13]
    ^ stream_b[13]
    ^ stream_a[14]
    ^ stream_b[14]
    ^ stream_a[15]
    ^ stream_b[15];

assign debug = ^debug_bus;

endmodule
