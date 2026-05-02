//----------------------------------------------------------------------------
// Example
//----------------------------------------------------------------------------

module fibonacci
(
  input               clk,
  input               rst,
  output logic [15:0] num
);

  logic [15:0] num2;

  always_ff @ (posedge clk)
    if (rst)
      { num, num2 } <= { 16'd1, 16'd1 };
    else
      { num, num2 } <= { num2, num + num2 };

endmodule

//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module fibonacci_2
(
  input               clk,
  input               rst,
  output logic [15:0] num,
  output logic [15:0] num2
);

  // Task:
  // Implement a module that generates two fibonacci numbers per cycle

  wire [15:0] next1 = num + num2;
  wire [15:0] next2 = num2 + next1;

  always_ff @(posedge clk)
    if (rst) begin
      num <= 16'b1;
      num2 <= 16'b1;
    end else begin
      num <= next1;
      num2 <= next2;
    end


endmodule
