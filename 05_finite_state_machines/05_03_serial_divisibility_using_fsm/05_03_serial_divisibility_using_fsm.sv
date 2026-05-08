//----------------------------------------------------------------------------
// Example
//----------------------------------------------------------------------------

module serial_divisibility_by_3_using_fsm
(
  input  clk,
  input  rst,
  input  new_bit,
  output div_by_3
);

  // States
  enum logic[1:0]
  {
     mod_0 = 2'b00,
     mod_1 = 2'b01,
     mod_2 = 2'b10
  }
  state, new_state;

  // State transition logic
  always_comb
  begin
    new_state = state;

    // This lint warning is bogus because we assign the default value above
    // verilator lint_off CASEINCOMPLETE

    case (state)
      mod_0 : if(new_bit) new_state = mod_1;
              else        new_state = mod_0;
      mod_1 : if(new_bit) new_state = mod_0;
              else        new_state = mod_2;
      mod_2 : if(new_bit) new_state = mod_2;
              else        new_state = mod_1;
    endcase

    // verilator lint_on CASEINCOMPLETE

  end

  // Output logic
  assign div_by_3 = state == mod_0;

  // State update
  always_ff @ (posedge clk)
    if (rst)
      state <= mod_0;
    else
      state <= new_state;

endmodule

//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module serial_divisibility_by_5_using_fsm
(
  input  clk,
  input  rst,
  input  new_bit,
  output div_by_5
);

  // Implement a module that performs a serial test if input number is divisible by 5.
  //
  // On each clock cycle, module receives the next 1 bit of the input number.
  // The module should set output to 1 if the currently known number is divisible by 5.
  //
  // Hint: new bit is coming to the right side of the long binary number `X`.
  // It is similar to the multiplication of the number by 2*X or by 2*X + 1.
  //
  // Hint 2: As we are interested only in the remainder, all operations are performed under the modulo 5 (% 5).
  // Check manually how the remainder changes under such modulo.

  logic [1:0] turn, remainder;

  // turn (x) | remainder l[x]: l = [(2**x) % 5 for x in range(8)] = [1, 2, 4, 3, 1, 2, 4, 3]
  // next_state logic: a = r (mod 5) and b = s (mod 5) -> a + b = r + s (mod 5)
  always_comb
    case (turn)
      2'b00: remainder = 2'b00;
      2'b01: remainder = 2'b01;
      2'b10: remainder = 2'b11;
      2'b11: remainder = 2'b10;
    endcase

  always_ff @(posedge clk)
    if (rst)
      turn <= '0;
    else
      turn <= turn + 1'b1;

  enum logic [2:0] {
    mod0 = 3'b000,
    mod1 = 3'b001,
    mod2 = 3'b010,
    mod3 = 3'b011,
    mod4 = 3'b100
  } state, next_state;

  always_ff @(posedge clk)
    if (rst)
      state = mod0;
    else
      state = next_state;

  always_comb begin
    next_state = state;
    if (new_bit)
      case (state)
        mod0:
          case(remainder)
            2'b00: next_state = mod1;
            2'b01: next_state = mod2;
            2'b10: next_state = mod3;
            2'b11: next_state = mod4;
          endcase
        mod1:
          case(remainder)
            2'b00: next_state = mod2;
            2'b01: next_state = mod3;
            2'b10: next_state = mod4;
            2'b11: next_state = mod0;
          endcase
        mod2:
          case(remainder)
            2'b00: next_state = mod3;
            2'b01: next_state = mod4;
            2'b10: next_state = mod0;
            2'b11: next_state = mod1;
          endcase
        mod3:
          case(remainder)
            2'b00: next_state = mod4;
            2'b01: next_state = mod0;
            2'b10: next_state = mod1;
            2'b11: next_state = mod2;
          endcase
        mod4:
          case(remainder)
            2'b00: next_state = mod0;
            2'b01: next_state = mod1;
            2'b10: next_state = mod2;
            2'b11: next_state = mod3;
          endcase
      endcase
  end

  assign div_by_5 = state == mod0;

endmodule
