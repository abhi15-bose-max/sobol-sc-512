//============================================================
// tb_mac_128_driver.vh
//
// Part 1
//
// Driver Infrastructure
//============================================================

//------------------------------------------------------------
// Driver Variables
//------------------------------------------------------------

integer test;

integer operand;

integer rom;

integer load_cycle;

integer buffer_index;

//------------------------------------------------------------
// Random Operand Information
//------------------------------------------------------------

// Probability values (0...255)

reg [7:0] probability_a [0:`DOT_PRODUCT_SIZE-1];
reg [7:0] probability_b [0:`DOT_PRODUCT_SIZE-1];

// Operand signs

reg expected_sign_a [0:`DOT_PRODUCT_SIZE-1];
reg expected_sign_b [0:`DOT_PRODUCT_SIZE-1];

//------------------------------------------------------------
// Expected MAC
//------------------------------------------------------------

integer expected_result;

integer positive_reference;
integer negative_reference;

//------------------------------------------------------------
// Simulation Parameters
//------------------------------------------------------------

parameter NUM_TESTS = 100;

//------------------------------------------------------------
// Utility Tasks
//------------------------------------------------------------

task reset_system;

begin

    //--------------------------------------------------------
    // Default Inputs
    //--------------------------------------------------------

    start = 1'b0;
    reset = 1'b1;

    //--------------------------------------------------------
    // Controller Inputs
    //--------------------------------------------------------

    for (operand = 0;
         operand < `DOT_PRODUCT_SIZE;
         operand = operand + 1)
    begin

        load_buffer_a[operand] = 1'b0;
        load_buffer_b[operand] = 1'b0;

        sign_a[operand] = 1'b0;
        sign_b[operand] = 1'b0;

        buffer_stream_a[operand] = {`STREAM_LENGTH{1'b0}};
        buffer_stream_b[operand] = {`STREAM_LENGTH{1'b0}};

    end

    //--------------------------------------------------------
    // ROM Addresses
    //--------------------------------------------------------

    for (rom = 0;
         rom < `NUM_ROMS;
         rom = rom + 1)
    begin

        rom_addr_a[rom] = 0;
        rom_addr_b[rom] = 0;

    end

    //--------------------------------------------------------
    // Hold Reset
    //--------------------------------------------------------

    repeat(5)
        @(posedge clk);

    reset = 1'b0;

    repeat(2)
        @(posedge clk);

end

endtask

//------------------------------------------------------------
// Placeholder Tasks
//
// These will be implemented in later parts.
//
// generate_random_operands()
// load_stream_buffers()
// run_experiment()
// collect_statistics()
//------------------------------------------------------------

//============================================================
// End of Driver Part 1
//============================================================


//============================================================
// Driver Part 2
//
// Stream Buffer Loader
//============================================================

task load_stream_buffers;

begin

    //--------------------------------------------------------
    // Eight loading cycles
    //--------------------------------------------------------

    for (load_cycle = 0;
         load_cycle < `LOAD_CYCLES;
         load_cycle = load_cycle + 1)
    begin

        //----------------------------------------------------
        // Program the 16 ROMs
        //----------------------------------------------------

        for (rom = 0;
             rom < `NUM_ROMS;
             rom = rom + 1)
        begin

            buffer_index = rom * `LOAD_CYCLES + load_cycle;

            //------------------------------------------------
            // Program ROM addresses
            //------------------------------------------------

            rom_addr_a[rom] = probability_a[buffer_index];
            rom_addr_b[rom] = probability_b[buffer_index];

        end

        //----------------------------------------------------
        // Allow ROM outputs to settle
        //----------------------------------------------------

        #1;

        //----------------------------------------------------
        // Copy ROM outputs into driver stream buses
        //----------------------------------------------------

        for (rom = 0;
             rom < `NUM_ROMS;
             rom = rom + 1)
        begin

            buffer_index = rom * `LOAD_CYCLES + load_cycle;

            buffer_stream_a[buffer_index] = rom_stream_a[rom];
            buffer_stream_b[buffer_index] = rom_stream_b[rom];

            sign_a[buffer_index] = expected_sign_a[buffer_index];
            sign_b[buffer_index] = expected_sign_b[buffer_index];

        end

        //----------------------------------------------------
        // Pulse LOAD
        //----------------------------------------------------

        for (operand = 0;
             operand < `DOT_PRODUCT_SIZE;
             operand = operand + 1)
        begin

            load_buffer_a[operand] = 1'b0;
            load_buffer_b[operand] = 1'b0;

        end

        for (rom = 0;
             rom < `NUM_ROMS;
             rom = rom + 1)
        begin

            buffer_index = rom * `LOAD_CYCLES + load_cycle;

            load_buffer_a[buffer_index] = 1'b1;
            load_buffer_b[buffer_index] = 1'b1;

        end

        @(posedge clk);

        //----------------------------------------------------
        // Remove LOAD
        //----------------------------------------------------

        for (operand = 0;
             operand < `DOT_PRODUCT_SIZE;
             operand = operand + 1)
        begin

            load_buffer_a[operand] = 1'b0;
            load_buffer_b[operand] = 1'b0;

        end

    end

end

endtask

//============================================================
// End of Driver Part 2
//============================================================


//============================================================
// Driver Part 3
//
// Random Operand Generation
// Controller Control Tasks
//============================================================

//------------------------------------------------------------
// Generate Random Operands
//------------------------------------------------------------

task generate_random_operands;

begin

    //--------------------------------------------------------
    // Generate random Sobol ROM addresses
    //
    // sobol.mem contains 202 stochastic values.
    // Each address returns two decorrelated streams:
    //
    //      stream_a
    //      stream_b
    //
    //--------------------------------------------------------

    for (operand = 0;
         operand < `DOT_PRODUCT_SIZE;
         operand = operand + 1)
    begin

        //----------------------------------------------------
        // Random ROM addresses
        //----------------------------------------------------

        probability_a[operand] = $urandom_range(0,201);
        probability_b[operand] = $urandom_range(0,201);

        //----------------------------------------------------
        // Random operand signs
        //----------------------------------------------------

        expected_sign_a[operand] = $urandom_range(0,1);
        expected_sign_b[operand] = $urandom_range(0,1);

    end

end

endtask

//------------------------------------------------------------
// Start Controller
//------------------------------------------------------------

task start_controller;

begin

    @(posedge clk);

    start = 1'b1;

    @(posedge clk);

    start = 1'b0;

end

endtask

//------------------------------------------------------------
// Wait for Controller Completion
//------------------------------------------------------------

task wait_for_done;

begin

    wait(done == 1'b1);

    @(posedge clk);

end

endtask

//------------------------------------------------------------
// Run One Complete Experiment
//------------------------------------------------------------

task run_single_experiment;

begin

    //--------------------------------------------------------
    // Generate random operands
    //--------------------------------------------------------

    generate_random_operands();

    //--------------------------------------------------------
    // Load all local stream buffers
    //--------------------------------------------------------

    load_stream_buffers();

    //--------------------------------------------------------
    // Start computation
    //--------------------------------------------------------

    start_controller();

    //--------------------------------------------------------
    // Wait for controller completion
    //--------------------------------------------------------

    wait_for_done();

end

endtask

//============================================================
// Driver Main Process
//============================================================

initial
begin

    //--------------------------------------------------------
    // Initialize DUT
    //--------------------------------------------------------

    reset_system();

    //--------------------------------------------------------
    // Placeholder
    //
    // Scoreboard will be added later.
    //--------------------------------------------------------

    for (test = 0;
         test < NUM_TESTS;
         test = test + 1)
    begin

        $display("------------------------------------------");
        $display("Running Test %0d", test);
        $display("------------------------------------------");

        run_single_experiment();

        $display("Completed Test %0d", test);

    end

    $display("------------------------------------------");
    $display("Simulation Finished");
    $display("------------------------------------------");

    $finish;

end

//============================================================
// End of Driver Part 3
//============================================================


