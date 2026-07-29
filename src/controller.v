/*
------------------------------------------------------------------------------
File        : controller.v

Description :
Finite State Machine (FSM) controlling the Sobol stochastic computing engine.

States

    IDLE
        Wait for start signal.

    LOAD
        Fill all local stream buffers from Sobol ROMs.

    COMPUTE
        Shift stochastic streams and enable accumulation.

    DONE
        Hold final result until reset.

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

localparam IDLE    = 2'b00;
localparam LOAD    = 2'b01;
localparam COMPUTE = 2'b10;
localparam DONE    = 2'b11;

reg [1:0] state;

integer load_counter;
integer compute_counter;

always @(posedge clk)
begin

    if (rst)
    begin
        state              <= IDLE;
        load_counter       <= 0;
        compute_counter    <= 0;

        load_enable        <= 0;
        shift_enable       <= 0;
        accumulate_enable  <= 0;
        done               <= 0;
    end

    else
    begin

        case(state)

        IDLE:
        begin
            load_enable       <= 0;
            shift_enable      <= 0;
            accumulate_enable <= 0;
            done              <= 0;

            if(start)
            begin
                state <= LOAD;
                load_counter <= 0;
            end
        end

        LOAD:
        begin
            load_enable <= 1;

            load_counter <= load_counter + 1;

            if(load_counter == (`LOAD_CYCLES-1))
            begin
                load_enable <= 0;
                state <= COMPUTE;
                compute_counter <= 0;
            end
        end

        COMPUTE:
        begin
            shift_enable <= 1;
            accumulate_enable <= 1;

            compute_counter <= compute_counter + 1;

            if(compute_counter == (`STREAM_LENGTH-1))
            begin
                shift_enable <= 0;
                accumulate_enable <= 0;
                state <= DONE;
            end
        end

        DONE:
        begin
            done <= 1;
        end

        endcase

    end

end

endmodule
