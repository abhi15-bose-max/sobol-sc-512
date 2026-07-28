/*
------------------------------------------------------------------------------
File        : config.vh

Description :
Global configuration parameters for the Sobol Stochastic Computing
architecture.

Only this file needs to change between the four repositories.

sobol-sc-512
sobol-sc-1000
sobol-sc-1024
sobol-sc-2048

------------------------------------------------------------------------------
*/

`ifndef CONFIG_VH
`define CONFIG_VH

// ============================================================================
// Sobol Library Parameters
// ============================================================================

// Length of one stochastic bitstream
`define STREAM_LENGTH      512

// Number of Sobol streams stored in the ROM
// (101 probabilities × 2 independent streams)
`define NUM_STREAMS        202

// Address width for 202 entries
`define ROM_ADDR_WIDTH     8


// ============================================================================
// Architecture Parameters
// ============================================================================

// Number of parallel MAC units
`define DOT_PRODUCT_SIZE   128

// Number of dual-read ROMs used during initialisation.
// This only affects loading latency, NOT computation latency.
`define NUM_ROMS           16

// Maximum popcount per clock = DOT_PRODUCT_SIZE
`define POPCOUNT_WIDTH     8

// Maximum accumulated value
// STREAM_LENGTH × DOT_PRODUCT_SIZE
`define ACC_WIDTH          17

`endif
