//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module conv_first_to_last_no_ready
# (
    parameter width = 8
)
(
    input                clock,
    input                reset,

    input                up_valid,
    input                up_first,
    input  [width - 1:0] up_data,

    output               down_valid,
    output               down_last,
    output [width - 1:0] down_data
);
    // Task:
    // Implement a module that converts 'first' input status signal
    // to the 'last' output status signal.
    //
    // See README for full description of the task with timing diagram.

    logic valid_d;
    logic [width - 1:0] data_d;

    always_ff @(posedge clock)
        if (reset) begin
            valid_d <= '0;
            data_d <= '0;
        end else if (up_valid) begin
            valid_d <= 1'b1;
            data_d <= up_data;
        end

    assign down_valid = up_valid && valid_d;
    assign down_last = up_valid && up_first;
    assign down_data = data_d;

endmodule
