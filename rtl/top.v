module top #(
    parameter N_SLIDE_SWITCHES = 8,
    parameter N_LEDS = 8
) (
    /* verilator lint_off UNUSED */
    input wire i_btn,
    input wire [N_SLIDE_SWITCHES-1:0] i_slide_switches,
    output wire [6:0] o_sseg_1,
    output wire [6:0] o_sseg_2,
    /* verilator lint_off UNDRIVEN */
    output wire [N_LEDS-1:0] o_leds,
    input wire i_clk,
    input wire i_reset
    /* lint_on */
);

  localparam COUNTER_N = 12;
  reg [COUNTER_N-1:0] r_counter;
  reg r_ce;
  always @(posedge i_clk) begin
    r_counter <= r_counter + 1;
  end
  assign r_ce = r_counter == 0;


  wire [3:0] r_sseg_1_data;
  wire [3:0] r_sseg_2_data;

  //wire o_valid;

  //wire [3:0] w_sign_mag_adder_out;
  //assign r_sseg_2_data = {1'b0, w_sign_mag_adder_out[2:0]};
  //assign o_leds[1] = w_sign_mag_adder_out[3];


  // always @(posedge i_clk) begin
  //   if (i_reset) r_sseg_1_data <= 0;
  //   else if (i_btn) r_sseg_1_data <= (r_sseg_1_data < 'hF) ? r_sseg_1_data + 1 : 0;
  // end

  hex_to_seven_seg u_hex_to_seven_seg_1 (
      .i_data(r_sseg_1_data),
      .o_data(o_sseg_1)
  );
  hex_to_seven_seg u_hex_to_seven_seg_2 (
      .i_data(r_sseg_2_data),
      .o_data(o_sseg_2)
  );


  //square_wave_gen u_square_wave_gen (
  //    .i_clk         (i_clk),
  //    .i_reset       (i_reset),
  //    .i_on_duration (10000 / 2),
  //    .i_off_duration(20000 / 2),
  //    .o_data        (o_leds[0])
  //);

  // sign_magnitude_adder u_sign_magnitude_adder(
  //   .i_a    (i_slide_switches[3:0]    ),
  //   .i_b    (i_slide_switches[7:4]    ),
  //   .o_data (w_sign_mag_adder_out )
  // );

  // priority_encoder u_priority_encoder (
  //     .i_req  ({4'b0, i_slide_switches}),
  //     .o_data (r_sseg_1_data),
  //     .o_valid(o_leds[0])
  // );

  // dual_priority_encoder u_dual_priority_encoder (
  //     .i_req    ({4'b0, i_slide_switches}),
  //     .o_data_1 (r_sseg_1_data),
  //     .o_data_2 (r_sseg_2_data),
  //     .o_1_valid(o_leds[0]),
  //     .o_2_valid(o_leds[1])
  // );


  shift_reg u_shift_reg (
      .i_reset      (i_slide_switches[7]),
      .i_clk        (i_clk),
      .i_ce         (r_ce),
      .i_we         (i_slide_switches[6]),
      .i_shift_left (i_slide_switches[5]),
      .i_shift_right(i_slide_switches[4]),
      .i_data       ({4'b0,i_slide_switches[3:0]}),
      .o_data       (o_leds)
  );



endmodule
