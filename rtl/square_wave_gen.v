`default_nettype none
module square_wave_gen #(
    parameter WIDTH = 16,
    parameter CLK_PERIOD_NS = 1
) (
    input wire i_clk,
    input wire i_reset,
    input wire [WIDTH-1:0] i_on_duration,
    input wire [WIDTH-1:0] i_off_duration,
    output wire o_data
);

  reg [WIDTH-1:0] r_counter = 0;

  always @(posedge i_clk) begin
    if (i_reset || (r_counter >= i_on_duration + i_off_duration)) r_counter <= 0;
    else r_counter <= r_counter + 1;
  end
  
  assign o_data = r_counter >= i_on_duration ? 0 : 1;
  
endmodule
