//----------------------------------------------------------------------------
// Example
//----------------------------------------------------------------------------

module mux
(
  input  d0, d1,
  input  sel,
  output y
);

  assign y = sel ? d1 : d0;

endmodule

//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module xor_gate_using_mux
(
    input  a,
    input  b,
    output o
);

  // Task:
  // Implement xor gate using instance(s) of mux,
  // constants 0 and 1, and wire connections

  wire zero = 1'b0;
  wire one = 1'b1;
  wire mux_out1, mux_out2;

  mux m1 (zero, one, b, mux_out1);
  mux m2 (one, zero, b, mux_out2);
  mux m3 (mux_out1, mux_out2, a, o);


endmodule
