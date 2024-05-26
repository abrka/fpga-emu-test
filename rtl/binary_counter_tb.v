`timescale 1ns / 10ps

// sim time unit 1ns
// sim time step 10ps
`default_nettype none
module binary_counter_tb ();

  localparam CLK_PERIOD = 2;
  localparam N = 8;
  reg r_clk, r_reset, r_ce, r_we, r_count_up, r_count_down;
  reg  [N-1:0] r_i_data;
  wire [N-1:0] w_o_data;

  binary_counter #(
      .N(N)
  ) u_binary_counter (
      .i_clk       (r_clk),
      .i_reset     (r_reset),
      .i_ce        (r_ce),
      .i_we        (r_we),
      .i_count_up  (r_count_up),
      .i_count_down(r_count_down),
      .i_data      (r_i_data),
      .o_data      (w_o_data)
  );

  //dump vcd
  initial begin
    $dumpfile("binary_counter.vcd");
    $dumpvars(0, binary_counter_tb);
  end

  //clock 20ns
  always begin
    r_clk = 1;
    #(CLK_PERIOD / 2);
    r_clk = 0;
    #(CLK_PERIOD / 2);
  end

  //reset for first cycle
  initial begin
    r_reset = 1;
    #(5) r_reset = 0;
  end

  initial begin
    // ===== initial input ===== 

    r_we = 0;
    r_ce = 1;
    r_count_up = 0;
    r_count_down = 0;
    r_i_data = 0;



    // ==== test load ===== 

    @(negedge r_reset);  // wait for reset to deassert
    @(negedge r_clk);  // wait one clock

    r_we = 1;
    r_i_data = 8'h2f;
    @(negedge r_clk);
    r_we = 0;

    repeat (2) @(negedge r_clk);


    // ==== test up counter and pause ==== 
    r_count_up = 1;
    repeat (10) @(negedge r_clk);
    r_count_up = 0;  // pause
    repeat (2) @(negedge r_clk);

    // ==== test down counter and wait until output is zero ==== 
    r_count_down = 1;
    wait(w_o_data == 0);
    r_count_down = 0;
    repeat (2) @(negedge r_clk);


    // === absolute delay ====
    #(CLK_PERIOD * 4);
    r_ce = 0;
    #(CLK_PERIOD * 4);

    //stop simulation
    repeat (2) @(negedge r_clk);
    $finish(0);
  end
endmodule
