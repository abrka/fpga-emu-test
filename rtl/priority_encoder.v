module priority_encoder #(
    parameter REQ_N = 12,
    parameter OUT_N = $clog2(REQ_N)
) (
    input wire [REQ_N-1:0] i_req,
    output reg [OUT_N-1:0] o_data,
    output reg o_valid
);


  reg [OUT_N-1:0] i;

  assign o_valid = i_req != 0;

  always @(*) begin
    o_data = 0;
    for (i = 0; i < REQ_N; i = i + 1) begin
      if (i_req[i] == 1) o_data = i;
    end

  end

endmodule
