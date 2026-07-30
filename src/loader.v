/*
------------------------------------------------------------------------------
File        : loader.v

Description :
Initialization controller for the Sobol stochastic computing engine.

The loader sequences the loading of the Local Stream Buffers from the Sobol
ROM banks.

Each clock during the LOAD phase:

    • 16 dual-read Sobol ROMs provide 32 stochastic streams
    • 32 Local Stream Buffers are loaded
    • After LOAD_CYCLES clocks, all buffers are initialized

The loader does not instantiate the ROMs or buffers.
It only generates the loading schedule.

------------------------------------------------------------------------------
*/

`include "config.vh"

module loader
(
    input  wire clk,
    input  wire rst,

    input  wire load_enable,

    output reg  [2:0] load_cycle,

    output wire loading,
    output wire done
);

// -----------------------------------------------------------------------------
// Load Cycle Counter
// -----------------------------------------------------------------------------

always @(posedge clk)
begin

    if (rst)
        load_cycle <= 3'd0;

    else if (load_enable && !done)
        load_cycle <= load_cycle + 3'd1;

end

// -----------------------------------------------------------------------------
// Status
// -----------------------------------------------------------------------------

assign loading = load_enable && !done;

assign done = (load_cycle == (`LOAD_CYCLES-1));

endmodule
