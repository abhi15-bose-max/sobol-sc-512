//============================================================
// tb_mac_128_scoreboard.vh
//
// Simple Verification Scoreboard
//============================================================

//------------------------------------------------------------
// Scoreboard Variables
//------------------------------------------------------------

integer experiment_count;

reg signed [`ACC_WIDTH:0] observed_result;

//------------------------------------------------------------
// Scoreboard Update
//------------------------------------------------------------

task scoreboard_update;

begin

    //--------------------------------------------------------
    // Read DUT Result
    //--------------------------------------------------------

    observed_result = signed_result;

    //--------------------------------------------------------
    // Display Experiment Result
    //--------------------------------------------------------

    $display("------------------------------------------");
    $display("Experiment : %0d", experiment_count);
    $display("SC MAC Result : %0d", observed_result);
    $display("------------------------------------------");

    experiment_count = experiment_count + 1;

end

endtask

//------------------------------------------------------------
// Final Report
//------------------------------------------------------------

task scoreboard_report;

begin

    $display("");
    $display("===========================================");
    $display("      STOCHASTIC MAC VERIFICATION");
    $display("===========================================");
    $display("Total Experiments : %0d", experiment_count);
    $display("Simulation Complete.");
    $display("===========================================");
    $display("");

end

endtask

//------------------------------------------------------------
// Automatic Scoreboard Update
//------------------------------------------------------------

always @(posedge done)
begin

    scoreboard_update();

    //--------------------------------------------------------
    // Print Final Report After Last Experiment
    //--------------------------------------------------------

    if (experiment_count == NUM_TESTS)
        scoreboard_report();

end

//============================================================
// End Scoreboard
//============================================================
