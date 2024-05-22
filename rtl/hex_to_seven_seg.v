module hex_to_seven_seg (
    input wire [15:0] i_data,
    output reg [6:0] o_data
);


  always @(*) begin
    case (i_data)
      'h0: o_data = 7'h3F;
      'h1: o_data = 7'h06;
      'h2: o_data = 7'h5B;
      'h3: o_data = 7'h4F;
      'h4: o_data = 7'h66;
      'h5: o_data = 7'h6D;
      'h6: o_data = 7'h7D;
      'h7: o_data = 7'h07;
      'h8: o_data = 7'h7F;
      'h9: o_data = 7'h67;
      'hA: o_data = 7'h77;
      'hB: o_data = 7'h7C;
      'hC: o_data = 7'h39;
      'hD: o_data = 7'h5E;
      'hE: o_data = 7'h79;
      'hF: o_data = 7'h71;
      default: o_data = 7'b0;
    endcase
  end

endmodule







