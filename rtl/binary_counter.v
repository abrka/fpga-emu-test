`default_nettype none
module binary_counter #(
    parameter N = 8
) (
    input wire i_clk,
    input wire i_reset,
    input wire i_ce,
    input wire i_we,
    input wire i_count_up,
    input wire i_count_down,
    input wire [N-1:0] i_data,
    output wire [N-1:0] o_data
);

  reg [N-1:0] r_counter = 0;
  assign o_data = r_counter;

  always @(posedge i_clk) begin
    if (i_ce) begin
      if (i_reset) r_counter <= 0;
      else if (i_we) r_counter <= i_data;
      else if (i_count_up) r_counter <= r_counter + 1;
      else if (i_count_down) r_counter <= r_counter - 1;
    end
  end

endmodule
