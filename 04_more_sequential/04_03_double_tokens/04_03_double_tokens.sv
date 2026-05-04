//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module double_tokens
(
    input        clk,
    input        rst,
    input        a,
    output       b,
    output logic overflow
);
    // Task:
    // Implement a serial module that doubles each incoming token '1' two times.
    // The module should handle doubling for at least 200 tokens '1' arriving in a row.
    //
    // In case module detects more than 200 sequential tokens '1', it should assert
    // an overflow error. The overflow error should be sticky. Once the error is on,
    // the only way to clear it is by using the "rst" reset signal.
    //
    // Note:
    // Check the waveform diagram in the README for better understanding.
    //
    // Example:
    // a -> 10010011000110100001100100
    // b -> 11011011110111111001111110

    logic [7:0] debt;
    logic out_token;

    always_ff @(posedge clk)
        if (rst) begin
            debt <= '0;
            overflow <= '0;
            out_token <= '0;
        end else if (a) begin
            debt <= debt + 1'b1;
            if (debt == 8'd200)
                overflow <= 1'b1;
            out_token <= 1'b1;
        end else if (!a && debt > 8'd0) begin
            debt <= debt - 1'b1;
            out_token <= 1'b1;
        end else
            out_token <= 1'b0;

    assign b = out_token;

endmodule
