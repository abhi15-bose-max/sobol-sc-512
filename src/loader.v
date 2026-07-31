/*
------------------------------------------------------------------------------
File        : loader.v

Description :
Memory subsystem for the Sobol stochastic computing engine.

The loader is responsible for:

    • Instantiating the Sobol ROM banks
    • Instantiating all Local Stream Buffers
    • Loading 32 streams per clock
    • Shifting one stochastic bit per clock after loading
    • Providing the current operand bits to the compute datapath

------------------------------------------------------------------------------
*/
/*
`include "config.vh"

module loader
(
    input wire clk,
    input wire rst,

    input wire load_enable,
    input wire shift_enable,

    output wire [`DOT_PRODUCT_SIZE-1:0] operand_a_bits,
    output wire [`DOT_PRODUCT_SIZE-1:0] operand_b_bits,

    output wire done
);

// -----------------------------------------------------------------------------
// Load Counter
// -----------------------------------------------------------------------------

reg [2:0] load_cycle;

always @(posedge clk)
begin

    if(rst)
        load_cycle <= 3'd0;

    else if(load_enable && !done)
        load_cycle <= load_cycle + 3'd1;

end

assign done = (load_cycle == (`LOAD_CYCLES-1));

// -----------------------------------------------------------------------------
// Sobol ROM Outputs
// -----------------------------------------------------------------------------

wire [`STREAM_LENGTH-1:0] rom_stream_a [0:`NUM_ROMS-1];
wire [`STREAM_LENGTH-1:0] rom_stream_b [0:`NUM_ROMS-1];

wire [`ROM_ADDR_WIDTH-1:0] rom_addr_a [0:`NUM_ROMS-1];
wire [`ROM_ADDR_WIDTH-1:0] rom_addr_b [0:`NUM_ROMS-1];

// -----------------------------------------------------------------------------
// Generate ROM Addresses
// -----------------------------------------------------------------------------

genvar r;

generate

for(r=0; r<`NUM_ROMS; r=r+1)
begin : ROM_ADDRESS_GEN

    assign rom_addr_a[r] = load_cycle*32 + r*2;
    assign rom_addr_b[r] = load_cycle*32 + r*2 + 1;

end

endgenerate

// -----------------------------------------------------------------------------
// Sobol ROMs
// -----------------------------------------------------------------------------

generate

for(r=0; r<`NUM_ROMS; r=r+1)
begin : ROMS

    sobol_rom rom_inst
    (
        .address_a(rom_addr_a[r]),
        .address_b(rom_addr_b[r]),

        .stream_a(rom_stream_a[r]),
        .stream_b(rom_stream_b[r])
    );

end

endgenerate

// -----------------------------------------------------------------------------
// Local Stream Buffers
// -----------------------------------------------------------------------------

wire buffer_bit [0:(2*`DOT_PRODUCT_SIZE)-1];

genvar b;

generate

for(b=0; b<(2*`DOT_PRODUCT_SIZE); b=b+1)
begin : BUFFERS

    local_stream_buffer buffer_inst
    (
        .clk(clk),
        .reset(rst),

        .load(load_enable),
        .shift(shift_enable),

        .stream_in(),        // Connected below

        .bit_out(buffer_bit[b])
    );

end

endgenerate

// -----------------------------------------------------------------------------
// Operand Bit Outputs
// -----------------------------------------------------------------------------

genvar i;

generate

for(i=0; i<`DOT_PRODUCT_SIZE; i=i+1)
begin

    assign operand_a_bits[i] = buffer_bit[2*i];
    assign operand_b_bits[i] = buffer_bit[2*i+1];

end

endgenerate

endmodule
*/
