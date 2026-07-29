/*
------------------------------------------------------------------------------
File        : controller.v

Description :
Finite State Machine (FSM) controlling the Sobol Stochastic Computing Engine.

------------------------------------------------------------------------------
*/

`include "config.vh"

module controller
(
    input wire clk,
    input wire rst,
    input wire start,

    output reg load_enable,
    output reg shift_enable,
    output reg accumulate_enable,
    output reg done
);

localparam IDLE    = 2'd0;
localparam LOAD    = 2'd1;
localparam COMPUTE = 2'd2;
localparam DONE    = 2'd3;

reg [1:0] state;

integer load_counter;
integer compute_counter;

always @(posedge clk)
begin

    if(rst)
    begin
        state <= IDLE;

        load_counter <= 0;
        compute_counter <= 0;

        load_enable <= 0;
        shift_enable <= 0;
        accumulate_enable <= 0;
        done <= 0;
    end

    else
    begin

        case(state)

        //----------------------------------------------------------
        // IDLE
        //----------------------------------------------------------

        IDLE:
        begin

            load_enable <= 0;
            shift_enable <= 0;
            accumulate_enable <= 0;
            done <= 0;

            load_counter <= 0;
            compute_counter <= 0;

            if(start)
                state <= LOAD;

        end

        //----------------------------------------------------------
        // LOAD
        //----------------------------------------------------------

        LOAD:
        begin

            load_enable <= 1;
            shift_enable <= 0;
            accumulate_enable <= 0;
            done <= 0;

            if(load_counter == (`LOAD_CYCLES-1))
            begin

                load_enable <= 0;

                load_counter <= 0;

                compute_counter <= 0;

                state <= COMPUTE;

            end
            else
            begin

                load_counter <= load_counter + 1;

            end

        end

        //----------------------------------------------------------
        // COMPUTE
        //----------------------------------------------------------

        COMPUTE:
        begin

            load_enable <= 0;
            shift_enable <= 1;
            accumulate_enable <= 1;
            done <= 0;

            if(compute_counter == (`STREAM_LENGTH-1))
            begin

                shift_enable <= 0;
                accumulate_enable <= 0;

                compute_counter <= 0;

                state <= DONE;

            end
            else
            begin

                compute_counter <= compute_counter + 1;

            end

        end

        //----------------------------------------------------------
        // DONE
        //----------------------------------------------------------

        DONE:
        begin

            load_enable <= 0;
            shift_enable <= 0;
            accumulate_enable <= 0;

            done <= 1;

        end

        endcase

    end

end

endmodule
