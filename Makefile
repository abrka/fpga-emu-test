PCF_FILE         =  test.pcf
VCD_FILE 		     =  build/test.vcd
SBY_FILE 		     =  formal/test.sby
SYNTH_V_SRCS     =  rtl/binary_counter.v rtl/dual_priority_encoder.v rtl/hex_to_seven_seg.v rtl/mod_n_counter.v rtl/priority_encoder.v rtl/rising_edge_detect.v rtl/shift_reg.v rtl/sign_magnitude_adder.v rtl/square_wave_gen.v rtl/sseg_time_mux.v rtl/top.v 
SYNTH_TOP_MODULE =  top
IVERILOG_SRCS	   =  rtl/binary_counter_tb.v rtl/binary_counter.v
 
YOSYS_FLAGS      =  -p 'synth_ice40 -json $(OUTPUT_JSON)'
NEXTPNR_FLAGS    =  --hx8k --package ct256 --pcf-allow-unconstrained
 
SYNTH_BUILD_DIR  =  synth_build
OUTPUT_ASC       =  $(SYNTH_BUILD_DIR)/test.asc
OUTPUT_JSON      =  $(SYNTH_BUILD_DIR)/test.json
OUTPUT_BIN       =  $(SYNTH_BUILD_DIR)/test.bin

.PHONY: clean sim synth view_vcd verify 

clean:
	rm -rf $(SYNTH_BUILD_DIR)

sim:
	iverilog $(IVERILOG_SRCS)
	./a.out
	rm -rf ./a.out

synth: $(SYNTH_V_SRCS)
	mkdir -p $(SYNTH_BUILD_DIR)
	yosys $(YOSYS_FLAGS) $(SYNTH_V_SRCS)
	nextpnr-ice40 $(NEXTPNR_FLAGS) --top $(SYNTH_TOP_MODULE) --pcf $(PCF_FILE) --json $(OUTPUT_JSON) --asc $(OUTPUT_ASC) 
	icepack $(OUTPUT_ASC) $(OUTPUT_BIN)

view_vcd:
	gtkwave $(VCD_FILE)

verify: 
	sby -f $(SBY_FILE)