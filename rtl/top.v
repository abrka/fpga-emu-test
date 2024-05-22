module top (

    input wire i_btn,
    output wire [6:0] o_sseg,
    output wire o_led,
    input wire i_clk,
    input wire i_reset
);

  reg [15:0] r_sseg_data = 0;

  always @(posedge i_clk) begin
    if (i_reset) r_sseg_data <= 0;
    else if (i_btn) r_sseg_data <= (r_sseg_data < 'hF) ? r_sseg_data + 1 : 0;
  end

  hex_to_seven_seg u_hex_to_seven_seg (
      .i_data(r_sseg_data),
      .o_data(o_sseg)
  );


  square_wave_gen u_square_wave_gen (
      .i_clk         (i_clk),
      .i_reset       (i_reset),
      .i_on_duration (10000 / 2),
      .i_off_duration(20000 / 2),
      .o_data        (o_led)
  );

endmodule
