/*
------------------------------------------------------------------------------
File        : config.vh

Description :
Global configuration parameters for the Sobol Stochastic Computing
architecture.

Only this file changes between the repositories:

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

// Number of stochastic streams stored in the Sobol ROM
// (101 probabilities × 2 independent Sobol streams)
`define NUM_STREAMS        202

// Address width required for NUM_STREAMS entries
`define ROM_ADDR_WIDTH     8


// ============================================================================
// Architecture Parameters
// ============================================================================

// Number of parallel stochastic MAC units
`define DOT_PRODUCT_SIZE   128

// Number of dual-read Sobol ROMs used during initialization
`define NUM_ROMS           16


// ============================================================================
// Derived Parameters
// ============================================================================

// Number of clock cycles required to load all local stream buffers
//
// Total buffers = 2 × DOT_PRODUCT_SIZE
// Streams loaded per cycle = 2 × NUM_ROMS
//
// LOAD_CYCLES = (2 × DOT_PRODUCT_SIZE) / (2 × NUM_ROMS)
//             = DOT_PRODUCT_SIZE / NUM_ROMS
//
`define LOAD_CYCLES        (`DOT_PRODUCT_SIZE / `NUM_ROMS)


// Maximum popcount value each clock
// Maximum = DOT_PRODUCT_SIZE
`define POPCOUNT_WIDTH     8

// Maximum accumulator width
// Maximum accumulated value = STREAM_LENGTH × DOT_PRODUCT_SIZE
//
// For 512 × 128 = 65536
//
`define ACC_WIDTH          17

`endif
