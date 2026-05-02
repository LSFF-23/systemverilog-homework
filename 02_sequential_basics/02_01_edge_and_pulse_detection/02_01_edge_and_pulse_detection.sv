//----------------------------------------------------------------------------
// Example
//----------------------------------------------------------------------------

module posedge_detector (input clk, rst, a, output detected);

  logic a_r;

  // Note:
  // The a_r flip-flop input value d propogates to the output q
  // only on the next clock cycle.

  always_ff @ (posedge clk)
    if (rst)
      a_r <= '0;
    else
      a_r <= a;

  assign detected = ~ a_r & a;

endmodule

//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module one_cycle_pulse_detector (input clk, rst, a, output detected);

  // Task:
  // Create an one cycle pulse (010) detector.
  //
  // Note:
  // See the testbench for the output format ($display task).

  logic a_sync1, a_sync2;

  always_ff @(posedge clk) begin
    if (rst) begin
      a_sync1 <= 1'b0;
      a_sync2 <= 1'b0;
    end else begin
      a_sync1 <= a;
      a_sync2 <= a_sync1;
    end
  end

  assign detected = !a & !a_sync2 & a_sync1;


endmodule
