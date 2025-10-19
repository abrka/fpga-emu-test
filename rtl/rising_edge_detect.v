module rising_edge_detect (
  input wire i_reset, i_clk, i_ce,
  input wire i_data,
  output reg o_data
);


shift_reg #(2) u_shift_reg (
  .i_reset       (i_reset       ),
  .i_ce          (i_ce          ),
  .i_clk         (i_clk         ),
  .i_we          (1             ),
  .i_shift_left  (1             ),
  .i_shift_right (0            ),
  .i_data        (i_data        ),
  .o_data        (o_data        )
);

endmodule

