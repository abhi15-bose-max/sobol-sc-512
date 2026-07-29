//============================================================
// tb_mac_128_infra.vh
//
// Part 1
//  - Includes
//  - Clock / Reset
//  - Controller
//  - ROM Infrastructure
//  - Global Signal Declarations
//============================================================

`include "../rtl/config.vh"

integer i;
integer j;

//============================================================
// Clock / Reset
//============================================================

reg clk;
reg reset;

initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
end

//============================================================
// Controller Interface
//============================================================

reg start;

wire load_enable;
wire shift_enable;
wire accumulate_enable;
wire done;

//============================================================
// Controller
//============================================================

controller controller_inst
(
    .clk                (clk),
    .reset              (reset),
    .start              (start),

    .load_enable        (load_enable),
    .shift_enable       (shift_enable),
    .accumulate_enable  (accumulate_enable),
    .done               (done)
);

//============================================================
// Sobol ROM Interface
//============================================================

// Address buses driven by the driver.

reg [`ROM_ADDR_WIDTH-1:0] rom_addr_a [0:`NUM_ROMS-1];
reg [`ROM_ADDR_WIDTH-1:0] rom_addr_b [0:`NUM_ROMS-1];

// Complete stochastic streams coming from ROMs.

wire [`STREAM_LENGTH-1:0] rom_stream_a [0:`NUM_ROMS-1];
wire [`STREAM_LENGTH-1:0] rom_stream_b [0:`NUM_ROMS-1];

//============================================================
// Sobol ROM Instances
//============================================================

genvar rom;

generate

    for (rom = 0; rom < `NUM_ROMS; rom = rom + 1)
    begin : GEN_SOBOL_ROMS

        sobol_rom sobol_rom_inst
        (
            .address_a (rom_addr_a[rom]),
            .address_b (rom_addr_b[rom]),

            .stream_a  (rom_stream_a[rom]),
            .stream_b  (rom_stream_b[rom])
        );

    end

endgenerate

//============================================================
// Local Stream Buffer Signals
//============================================================

// Driver will assert these individually during LOAD state.

reg load_buffer_a [0:`DOT_PRODUCT_SIZE-1];
reg load_buffer_b [0:`DOT_PRODUCT_SIZE-1];

// Shift comes directly from controller.

wire shift_buffers;

assign shift_buffers = shift_enable;

//============================================================
// Buffer Outputs
//============================================================

wire buffer_bit_a [0:`DOT_PRODUCT_SIZE-1];
wire buffer_bit_b [0:`DOT_PRODUCT_SIZE-1];

//============================================================
// Buffer Inputs
//
// These wires connect each local stream buffer to one ROM.
// The driver will determine which ROM address corresponds
// to each buffer during each LOAD cycle.
//
// The actual assignments are intentionally left to the
// driver include so that ROM scheduling stays outside the
// hardware architecture.
//============================================================

reg [`STREAM_LENGTH-1:0] buffer_stream_a
    [0:`DOT_PRODUCT_SIZE-1];

reg [`STREAM_LENGTH-1:0] buffer_stream_b
    [0:`DOT_PRODUCT_SIZE-1];

//============================================================
// Multiplier Signals
//============================================================

wire multiplier_out [0:`DOT_PRODUCT_SIZE-1];

//============================================================
// Sign Routing
//============================================================

reg sign_a [0:`DOT_PRODUCT_SIZE-1];
reg sign_b [0:`DOT_PRODUCT_SIZE-1];

wire positive_bit [0:`DOT_PRODUCT_SIZE-1];
wire negative_bit [0:`DOT_PRODUCT_SIZE-1];

//============================================================
// Popcount Inputs
//============================================================

wire [`DOT_PRODUCT_SIZE-1:0] positive_vector;
wire [`DOT_PRODUCT_SIZE-1:0] negative_vector;

// Pack individual routed bits into vectors.

generate

    genvar pack;

    for (pack = 0;
         pack < `DOT_PRODUCT_SIZE;
         pack = pack + 1)
    begin : PACK_ROUTED_BITS

        assign positive_vector[pack] = positive_bit[pack];
        assign negative_vector[pack] = negative_bit[pack];

    end

endgenerate

//============================================================
// Popcount Outputs
//============================================================

wire [`POPCOUNT_WIDTH-1:0] positive_count;
wire [`POPCOUNT_WIDTH-1:0] negative_count;

//============================================================
// Accumulator Outputs
//============================================================

wire signed [`ACC_WIDTH-1:0] positive_sum;
wire signed [`ACC_WIDTH-1:0] negative_sum;

//============================================================
// Final Result
//============================================================

wire signed [`ACC_WIDTH-1:0] signed_result;

//============================================================
// End of Part 1
//============================================================


//============================================================
// Part 2
//
// Local Stream Buffers
//============================================================

genvar buf;

generate

    //--------------------------------------------------------
    // Operand A Buffers
    //--------------------------------------------------------

    for (buf = 0;
         buf < `DOT_PRODUCT_SIZE;
         buf = buf + 1)
    begin : GEN_BUFFER_A

        local_stream_buffer buffer_a_inst
        (
            .clk        (clk),
            .reset      (reset),

            .load       (load_buffer_a[buf]),
            .shift      (shift_buffers),

            .stream_in  (buffer_stream_a[buf]),

            .bit_out    (buffer_bit_a[buf])
        );

    end

endgenerate


generate

    //--------------------------------------------------------
    // Operand B Buffers
    //--------------------------------------------------------

    for (buf = 0;
         buf < `DOT_PRODUCT_SIZE;
         buf = buf + 1)
    begin : GEN_BUFFER_B

        local_stream_buffer buffer_b_inst
        (
            .clk        (clk),
            .reset      (reset),

            .load       (load_buffer_b[buf]),
            .shift      (shift_buffers),

            .stream_in  (buffer_stream_b[buf]),

            .bit_out    (buffer_bit_b[buf])
        );

    end

endgenerate

//============================================================
// End of Part 2
//============================================================



