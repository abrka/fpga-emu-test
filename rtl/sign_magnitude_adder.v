
module sign_magnitude_adder #(
    parameter N = 4
) (
    input  wire [N-1:0] i_a,
    input  wire [N-1:0] i_b,
    output reg  [N-1:0] o_data
);

  localparam SIGN_BIT = N - 1;
  reg r_sign_bit;
  reg [N-2:0] r_sum;

  assign o_data = {r_sign_bit, r_sum};

  /* verilator lint_off UNUSED */
  reg [N-1:0] r_bigger_num;
  assign r_bigger_num = i_a[N-2:0] > i_b[N-2:0] ? i_a : i_b;

  reg [N-1:0] r_smaller_num;
  /* lint_on */
  assign r_smaller_num = i_a[N-2:0] < i_b[N-2:0] ? i_a : i_b;

  always @(*) begin

    if (i_a[SIGN_BIT] == i_b[SIGN_BIT]) begin
      r_sign_bit = i_a[SIGN_BIT];
      r_sum = i_a[N-2:0] + i_b[N-2:0];
    end else begin
      r_sign_bit = r_bigger_num[SIGN_BIT];
      r_sum = r_bigger_num[N-2:0] - r_smaller_num[N-2:0];
    end

  end

`ifdef FORMAL
  always @(*) begin
    if (i_a[N-1] == i_b[N-1]) begin
      assert (o_data[N-1] == i_a[N-1]);
      assert (o_data[N-2:0] == i_a[N-2:0] + i_b[N-2:0]);
    end else if (i_a[N-2] > i_b[N-2]) begin
      assert (o_data[N-1] == i_a[N-1]);
      assert (o_data[N-2:0] == i_a[N-2:0] - i_b[N-2:0]);
    end else if (i_b[N-2] > i_a[N-2]) begin
      assert (o_data[N-1] == i_b[N-1]);
      assert (o_data[N-2:0] == i_b[N-2:0] - i_a[N-2:0]);
    end
  end

`endif
endmodule
