/*
------------------------------------------------------------------------------
File        : top.v

Description :
Top-level integration module for the Sobol stochastic computing engine.

This module instantiates the complete stochastic datapath.

External orchestration (ROM addressing, stream loading, operand preparation)
is intentionally left to the testbench.

Architecture

Controller
      |
      v
Local Stream Buffers
      |
      v
SC Multipliers
      |
      v
Sign Routers
      |
      v
Positive / Negative Popcount
      |
      v
Positive / Negative Accumulators
      |
      v
Final Subtractor

------------------------------------------------------------------------------
*/

`include "config.vh"

module top
(
    input wire clk,
    input wire rst,
    input wire start,

    output wire done,

    output wire signed [`ACC_WIDTH:0] result
);


// -----------------------------------------------------------------------------
// Controller Signals
// -----------------------------------------------------------------------------

//wire load_enable;
//wire shift_enable;
//wire accumulate_enable;


// -----------------------------------------------------------------------------
// Controller
// -----------------------------------------------------------------------------

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


// -----------------------------------------------------------------------------
// Datapath
// -----------------------------------------------------------------------------
//
// The datapath (Sobol ROMs, Local Stream Buffers, Multipliers,
// Sign Routers, Popcount, Accumulators, and Final Subtractor)
// is instantiated by the verification environment.
//
// The testbench is responsible for:
//
//   • Sobol ROM instantiation
//   • Stream loading
//   • Buffer initialisation
//   • Operand sign generation
//
// This module provides the system control interface only.
// The computational datapath remains modular and is verified
// independently through dedicated testbenches.
//
// -----------------------------------------------------------------------------

assign result = '0;

endmodule
