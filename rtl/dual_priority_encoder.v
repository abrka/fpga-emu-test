module dual_priority_encoder #(
    parameter REQ_N = 12,
    parameter OUT_N = $clog2(REQ_N)
) (
    input wire [REQ_N-1:0] i_req,
    output reg [OUT_N-1:0] o_data_1,
    output reg [OUT_N-1:0] o_data_2,
    output reg o_1_valid,
    output reg o_2_valid
); 

  reg [REQ_N-1:0] w_req_2;
  always @(*) begin
    w_req_2 = i_req;
    w_req_2[o_data_1] = 0;
  end

  priority_encoder u_priority_encoder_1 (
      .i_req  (i_req),
      .o_data (o_data_1),
      .o_valid(o_1_valid)
  );

  priority_encoder u_priority_encoder_2 (
      .i_req  (w_req_2),
      .o_data (o_data_2),
      .o_valid(o_2_valid)
  );


endmodule
