module shift_reg #(
    parameter N = 8
) (
    input wire i_reset,
    input wire i_ce,
    input wire i_clk,
    input wire i_we,
    input wire i_shift_left,
    input wire i_shift_right,
    input wire [N-1:0] i_data,
    output wire [N-1:0] o_data
);

  reg [N-1:0] r_data = 0;
  assign o_data = r_data;

  always @(posedge i_clk) begin
    if (i_ce) begin
      if (i_reset) r_data <= 0;
      else if (i_we) r_data <= i_data;
      else if (i_shift_left) r_data <= r_data << 1;
      else if (i_shift_right) r_data <= r_data >> 1;
    end
  end

endmodule
