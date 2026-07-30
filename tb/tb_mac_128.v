`timescale 1ns/1ps
`include "config.vh"

module tb_mac_128;

//======================================================================
// Parameters
//======================================================================

localparam NUM_OPERANDS = 128;
localparam STREAM_LENGTH = `STREAM_LENGTH;
localparam ROM_DEPTH = 202;


//======================================================================
// Clock / Reset
//======================================================================

reg clk;
reg rst;
reg start;

wire done;

initial clk = 0;
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
// We bypass the Sobol ROM hardware.
//
// The entire Sobol library is loaded once at simulation startup.
//
// Each entry corresponds to one deterministic Sobol stream pair.
//

reg [2*STREAM_LENGTH-1:0] sobol_library [0:ROM_DEPTH-1];

initial
begin
    $display("---------------------------------------------");
    $display("Loading Sobol library...");
    $readmemb("library/sobol.mem", sobol_library);
    $display("Loaded %0d Sobol entries.", ROM_DEPTH);
    $display("---------------------------------------------");
end;


//======================================================================
// Stream Storage
//======================================================================
//
// Each multiplier receives one A stream and one B stream.
//

reg [STREAM_LENGTH-1:0] stream_a [0:NUM_OPERANDS-1];
reg [STREAM_LENGTH-1:0] stream_b [0:NUM_OPERANDS-1];

reg sign_a [0:NUM_OPERANDS-1];
reg sign_b [0:NUM_OPERANDS-1];


//======================================================================
// Multiplier Outputs
//======================================================================

wire [STREAM_LENGTH-1:0] mult_stream [0:NUM_OPERANDS-1];


//======================================================================
// Router Outputs
//======================================================================

wire [STREAM_LENGTH-1:0] positive_stream [0:NUM_OPERANDS-1];
wire [STREAM_LENGTH-1:0] negative_stream [0:NUM_OPERANDS-1];


//======================================================================
// Generate Blocks
//======================================================================

genvar i;

generate

for(i=0;i<NUM_OPERANDS;i=i+1)
begin : MAC_PIPELINE

    //--------------------------------------------------------------
    // Stochastic Multiplier
    //--------------------------------------------------------------

    sc_multiplier multiplier_inst
    (
        .stream_a(stream_a[i]),
        .stream_b(stream_b[i]),
        .stream_out(mult_stream[i])
    );

    //--------------------------------------------------------------
    // Sign Router
    //--------------------------------------------------------------

    sign_router router_inst
    (
        .stream_in(mult_stream[i]),

        .sign_a(sign_a[i]),
        .sign_b(sign_b[i]),

        .positive_stream(positive_stream[i]),
        .negative_stream(negative_stream[i])
    );

end

endgenerate;


//======================================================================
// Remaining datapath
//======================================================================
//
// Part 2:
//
//  • Positive Popcount
//  • Negative Popcount
//  • Positive Accumulator
//  • Negative Accumulator
//  • Final Subtractor
//
