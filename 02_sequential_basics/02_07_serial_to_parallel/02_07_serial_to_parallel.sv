//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module serial_to_parallel
# (
    parameter width = 8
)
(
    input                      clk,
    input                      rst,

    input                      serial_valid,
    input                      serial_data,

    output logic               parallel_valid,
    output logic [width - 1:0] parallel_data
);
    // Task:
    // Implement a module that converts single-bit serial data to the multi-bit parallel value.
    //
    // The module should accept one-bit values with valid interface in a serial manner.
    // After accumulating 'width' bits and receiving last 'serial_valid' input,
    // the module should assert the 'parallel_valid' at the same clock cycle
    // and output 'parallel_data' value.
    //
    // Note:
    // Check the waveform diagram in the README for better understanding.

    localparam csize = $clog2(width);
    logic [csize - 1:0] bit_counter;

    always_ff @(posedge clk)
        if (rst) begin
            parallel_data <= '0;
            parallel_valid <= '0;
            bit_counter <= '0;
        end else if (serial_valid) begin
            parallel_data[bit_counter] <= serial_data;
            {parallel_valid, bit_counter} <= bit_counter + 1'b1;
        end else
            parallel_valid <= '0;

endmodule
