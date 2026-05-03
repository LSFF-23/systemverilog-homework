//----------------------------------------------------------------------------
// Example
//----------------------------------------------------------------------------

module sort_two_floats_ab (
    input        [FLEN - 1:0] a,
    input        [FLEN - 1:0] b,

    output logic [FLEN - 1:0] res0,
    output logic [FLEN - 1:0] res1,
    output                    err
);

    logic a_less_or_equal_b;

    f_less_or_equal i_floe (
        .a   ( a                 ),
        .b   ( b                 ),
        .res ( a_less_or_equal_b ),
        .err ( err               )
    );

    always_comb begin : a_b_compare
        if ( a_less_or_equal_b ) begin
            res0 = a;
            res1 = b;
        end
        else
        begin
            res0 = b;
            res1 = a;
        end
    end

endmodule

//----------------------------------------------------------------------------
// Example - different style
//----------------------------------------------------------------------------

module sort_two_floats_array
(
    input        [0:1][FLEN - 1:0] unsorted,
    output logic [0:1][FLEN - 1:0] sorted,
    output                         err
);

    logic u0_less_or_equal_u1;

    f_less_or_equal i_floe
    (
        .a   ( unsorted [0]        ),
        .b   ( unsorted [1]        ),
        .res ( u0_less_or_equal_u1 ),
        .err ( err                 )
    );

    always_comb
        if (u0_less_or_equal_u1)
            sorted = unsorted;
        else
              {   sorted [0],   sorted [1] }
            = { unsorted [1], unsorted [0] };

endmodule

//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module sort_three_floats (
    input        [0:2][FLEN - 1:0] unsorted,
    output logic [0:2][FLEN - 1:0] sorted,
    output                         err
);

    // Task:
    // Implement a module that accepts three Floating-Point numbers and outputs them in the increasing order.
    // The module should be combinational with zero latency.
    // The solution can use up to three instances of the "f_less_or_equal" module.
    //
    // Notes:
    // res0 must be less or equal to the res1
    // res1 must be less or equal to the res2
    //
    // The FLEN parameter is defined in the "import/preprocessed/cvw/config-shared.vh" file
    // and usually equal to the bit width of the double-precision floating-point number, FP64, 64 bits.
    
    wire [FLEN - 1:0] a = unsorted[0];
    wire [FLEN - 1:0] b = unsorted[1];
    wire [FLEN - 1:0] c = unsorted[2];
    wire a_gt_b, a_gt_c, b_gt_c;
    wire [2:0] err_signal;

    assign err = |err_signal;

    f_less_or_equal floe1 (.a(a), .b(b), .res(a_gt_b), .err(err_signal[0]));
    f_less_or_equal floe2 (.a(a), .b(c), .res(a_gt_c), .err(err_signal[1]));
    f_less_or_equal floe3 (.a(b), .b(c), .res(b_gt_c), .err(err_signal[2]));

    always_comb
        case ({a_gt_b, a_gt_c, b_gt_c})
            3'b000: sorted = {c, b, a}; // a <= b, a <= c, b <= c
            3'b001: sorted = {b, c, a}; // a <= b, a <= c, b > c
            3'b010: sorted = {b, a, c}; // a <= b, a > c, b <= c
            3'b011: sorted = {b, a, c}; // a <= b, a > c, b > c
            3'b100: sorted = {c, a, b}; // a > b, a <= c, b <= c
            3'b101: sorted = {a, b, c}; // a > b, a <= c, b > c (impossible)
            3'b110: sorted = {a, c, b}; // a > b, a > c, b <= c
            3'b111: sorted = {a, b, c}; // a > b, a > c, b > c
        endcase


endmodule
