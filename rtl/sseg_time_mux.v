module sseg_time_mux (
    input wire i_clk,
    input wire i_reset,
    input wire i_ce,
    input wire [6:0] i_sseg_1,
    input wire [6:0] i_sseg_2,
    input wire [6:0] i_sseg_3,
    input wire [6:0] i_sseg_4,
    output reg [N_SSEG_INPUTS-1:0] o_sseg_enables,
    output reg [6:0] o_sseg
);

  localparam N_SSEG_INPUTS = 4;

  reg [$clog2(N_SSEG_INPUTS)-1:0] r_currently_servicing_sseg = 0;

  always @(posedge i_clk) begin
    if (i_ce) begin
      if (i_reset) r_currently_servicing_sseg <= 0;
      else r_currently_servicing_sseg <= r_currently_servicing_sseg + 1;
    end
  end

  always @(*) begin
    o_sseg_enables = 0;
    o_sseg_enables[r_currently_servicing_sseg] = 1;

    case (r_currently_servicing_sseg)
      0: o_sseg = i_sseg_1;
      1: o_sseg = i_sseg_2;
      2: o_sseg = i_sseg_3;
      3: o_sseg = i_sseg_4; 
      default: o_sseg = 0;
    endcase

  end




endmodule
