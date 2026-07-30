`timescale 1ns/1ps
`include "config.vh"

module tb_mac_128;

//======================================================================
// Parameters
//======================================================================

localparam NUM_OPERANDS  = `DOT_PRODUCT_SIZE;
localparam STREAM_LENGTH = `STREAM_LENGTH;
localparam ROM_DEPTH     = 202;


//======================================================================
// Clock / Reset
//======================================================================

reg clk;
reg rst;
reg start;

wire done;

initial
    clk = 1'b0;

always #5 clk = ~clk;


//======================================================================
// Controller
//======================================================================

wire load_enable;
wire shift_enable;
wire accumulate_enable;

controller controller_inst
(
    .clk(clk),
    .rst(rst),
    .start(start),

    .load_enable(load_enable),
    .shift_enable(shift_enable),
    .accumulate_enable(accumulate_enable),

    .done(done)
);


//======================================================================
// Sobol Library
//======================================================================
//
// The complete Sobol memory is loaded once.
//
// Part 3 will unpack entries from this library into the operand streams.
//

reg [2*STREAM_LENGTH-1:0] sobol_library [0:ROM_DEPTH-1];

initial
begin
    $display("------------------------------------------------");
    $display("Loading Sobol Library...");
    $readmemb("library/sobol.mem", sobol_library);
    $display("Sobol Library Loaded.");
    $display("------------------------------------------------");
end;


//======================================================================
// Operand Stream Storage
//======================================================================
//
// Each MAC operand owns one complete stochastic stream.
//

reg [STREAM_LENGTH-1:0] stream_a [0:NUM_OPERANDS-1];
reg [STREAM_LENGTH-1:0] stream_b [0:NUM_OPERANDS-1];

reg sign_a [0:NUM_OPERANDS-1];
reg sign_b [0:NUM_OPERANDS-1];


//======================================================================
// Current Bit Index
//======================================================================
//
// Indicates which stochastic bit is currently being processed.
//

integer bit_index;


//======================================================================
// Current Operand Bits
//======================================================================
//
// One bit from every stochastic stream is presented to the hardware
// every clock cycle.
//

wire current_bit_a [0:NUM_OPERANDS-1];
wire current_bit_b [0:NUM_OPERANDS-1];


//======================================================================
// Multiplier Outputs
//======================================================================

wire product_bit [0:NUM_OPERANDS-1];


//======================================================================
// Router Outputs
//======================================================================

wire positive_bit [0:NUM_OPERANDS-1];
wire negative_bit [0:NUM_OPERANDS-1];


//======================================================================
// Generate Hardware
//======================================================================

genvar i;

generate

for(i = 0; i < NUM_OPERANDS; i = i + 1)
begin : MAC_ARRAY

    //--------------------------------------------------------------
    // Select current stochastic bit
    //--------------------------------------------------------------

    assign current_bit_a[i] = stream_a[i][bit_index];
    assign current_bit_b[i] = stream_b[i][bit_index];


    //--------------------------------------------------------------
    // Stochastic Multiplier
    //--------------------------------------------------------------

    sc_multiplier multiplier_inst
    (
        .a_bit(current_bit_a[i]),
        .b_bit(current_bit_b[i]),
        .product_bit(product_bit[i])
    );


    //--------------------------------------------------------------
    // Sign Router
    //--------------------------------------------------------------

    sign_router router_inst
    (
        .product_bit(product_bit[i]),

        .sign_a(sign_a[i]),
        .sign_b(sign_b[i]),

        .positive_bit(positive_bit[i]),
        .negative_bit(negative_bit[i])
    );

end

endgenerate;


//======================================================================
// Remaining Datapath
//======================================================================
//
// Part 2:
//
//   • Pack positive_bit[] / negative_bit[]
//   • Popcount
//   • Positive accumulator
//   • Negative accumulator
//   • Final subtractor
//

//
//======================================================================
// Popcount Inputs
//======================================================================
//
// One routed stochastic bit from each MAC.
//

wire [NUM_OPERANDS-1:0] positive_bits;
wire [NUM_OPERANDS-1:0] negative_bits;


//======================================================================
// Router Output Packing
//======================================================================

genvar j;

generate

for(j = 0; j < NUM_OPERANDS; j = j + 1)
begin : PACK_ROUTER_BITS

    assign positive_bits[j] = positive_bit[j];
    assign negative_bits[j] = negative_bit[j];

end

endgenerate


//======================================================================
// Popcount Outputs
//======================================================================

wire [`POPCOUNT_WIDTH-1:0] positive_count;
wire [`POPCOUNT_WIDTH-1:0] negative_count;


//======================================================================
// Popcount Units
//======================================================================

popcount positive_popcount_inst
(
    .bits(positive_bits),
    .count(positive_count)
);


popcount negative_popcount_inst
(
    .bits(negative_bits),
    .count(negative_count)
);


//======================================================================
// Accumulator Outputs
//======================================================================

wire [`ACC_WIDTH-1:0] positive_sum;
wire [`ACC_WIDTH-1:0] negative_sum;


//======================================================================
// Positive Accumulator
//======================================================================

positive_accumulator positive_accumulator_inst
(
    .clk(clk),
    .rst(rst),

    .enable(accumulate_enable),

    .count(positive_count),

    .accumulated_sum(positive_sum)
);


//======================================================================
// Negative Accumulator
//======================================================================

negative_accumulator negative_accumulator_inst
(
    .clk(clk),
    .rst(rst),

    .enable(accumulate_enable),

    .count(negative_count),

    .accumulated_sum(negative_sum)
);


//======================================================================
// Final Subtractor
//======================================================================

wire signed [`ACC_WIDTH:0] signed_result;


final_subtractor final_subtractor_inst
(
    .positive_sum(positive_sum),
    .negative_sum(negative_sum),

    .signed_result(signed_result)
);


