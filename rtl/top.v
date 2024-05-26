`default_nettype none
module top #(
    parameter N_SLIDE_SWITCHES = 8,
    parameter N_LEDS = 8,
    parameter N_SSEGS = 4
) (
    /* verilator lint_off UNUSED */
    input wire i_btn,
    input wire [N_SLIDE_SWITCHES-1:0] i_slide_switches,
    output wire [6:0] o_sseg,
    output wire [N_SSEGS-1:0] o_sseg_enables,
    /* verilator lint_off UNDRIVEN */
    output wire [N_LEDS-1:0] o_leds,
    input wire i_clk,
    input wire i_reset
    /* lint_on */
);


  localparam COUNTER_THERESHOLD = 4000;
  localparam COUNTER_N = $clog2(COUNTER_THERESHOLD);

  wire [COUNTER_N-1:0] w_counter;
  mod_n_counter #(COUNTER_THERESHOLD) u_mod_n_counter
   (
      .i_clk       (i_clk),
      .i_reset     (i_reset),
      .i_ce        (1),
      .i_data      (0),
      .i_we        (0),
      .i_count_up  (1),
      .i_count_down(0),
      .o_data      (w_counter)
  );

  // reg [COUNTER_N-1:0] r_counter = 0;
  // always @(posedge i_clk) begin
  //   if (r_counter > COUNTER_THERESHOLD) r_counter <= 0;
  //   else r_counter <= r_counter + 1;
  // end

  wire w_ce;
  assign w_ce = w_counter == COUNTER_THERESHOLD - 1;


  wire [3:0] w_sseg_1_data = 'h3;
  wire [3:0] w_sseg_2_data = 'hA;
  wire [3:0] w_sseg_3_data = 'h6;
  wire [3:0] w_sseg_4_data = 'hD;

  wire [6:0] w_sseg_1;
  wire [6:0] w_sseg_2;
  wire [6:0] w_sseg_3;
  wire [6:0] w_sseg_4;

  hex_to_seven_seg u_hex_to_seven_seg_1 (
      .i_data(w_sseg_1_data),
      .o_data(w_sseg_1)
  );
  hex_to_seven_seg u_hex_to_seven_seg_2 (
      .i_data(w_sseg_2_data),
      .o_data(w_sseg_2)
  );
  hex_to_seven_seg u_hex_to_seven_seg_3 (
      .i_data(w_sseg_3_data),
      .o_data(w_sseg_3)
  );
  hex_to_seven_seg u_hex_to_seven_seg_4 (
      .i_data(w_sseg_4_data),
      .o_data(w_sseg_4)
  );

  sseg_time_mux u_sseg_time_mux (
      .i_clk         (i_clk),
      .i_reset       (i_reset),
      .i_ce          (w_ce),
      .i_sseg_1      (w_sseg_1),
      .i_sseg_2      (w_sseg_2),
      .i_sseg_3      (w_sseg_3),
      .i_sseg_4      (w_sseg_4),
      .o_sseg_enables(o_sseg_enables),
      .o_sseg        (o_sseg)
  );


  binary_counter u_binary_counter (
      .i_clk       (i_clk),
      .i_reset     (i_slide_switches[7]),
      .i_ce        (w_ce),
      .i_we        (i_slide_switches[6]),
      .i_count_up  (i_slide_switches[5]),
      .i_count_down(i_slide_switches[4]),
      .i_data      ({4'b0, i_slide_switches[3:0]}),
      .o_data      (o_leds)
  );




  // shift_reg u_shift_reg (
  //     .i_reset      (i_slide_switches[7]),
  //     .i_clk        (i_clk),
  //     .i_ce         (w_ce),
  //     .i_we         (i_slide_switches[6]),
  //     .i_shift_left (i_slide_switches[5]),
  //     .i_shift_right(i_slide_switches[4]),
  //     .i_data       ({4'b0, i_slide_switches[3:0]}),
  //     .o_data       (o_leds)
  // );

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

  //wire o_valid;

  //wire [3:0] w_sign_mag_adder_out;
  //assign r_sseg_2_data = {1'b0, w_sign_mag_adder_out[2:0]};
  //assign o_leds[1] = w_sign_mag_adder_out[3];


  // always @(posedge i_clk) begin
  //   if (i_reset) r_sseg_1_data <= 0;
  //   else if (i_btn) r_sseg_1_data <= (r_sseg_1_data < 'hF) ? r_sseg_1_data + 1 : 0;
  // end

endmodule
