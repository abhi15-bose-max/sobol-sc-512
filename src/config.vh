/*
------------------------------------------------------------------------------
File        : config.vh

Description :
Global configuration parameters for the Sobol Stochastic Computing
architecture.

Changing STREAM_LENGTH is sufficient to create repositories for
512, 1000, 1024 or 2048-bit stochastic streams.

DOT_PRODUCT_SIZE determines the number of parallel MAC units.

------------------------------------------------------------------------------
*/

`ifndef CONFIG_VH
`define CONFIG_VH

// ============================================================
// Sobol Library Parameters
// ============================================================

`define STREAM_LENGTH      512
`define NUM_STREAMS        202

// 202 entries require 8 address bits
`define ROM_ADDR_WIDTH     8

// ============================================================
// Architecture Parameters
// ============================================================

// Number of parallel MAC units
`define DOT_PRODUCT_SIZE   128

// Maximum popcount per clock = 128
`define POPCOUNT_WIDTH     8

// Maximum accumulated count = 512 × 128 = 65536
`define ACC_WIDTH          17

`endif
