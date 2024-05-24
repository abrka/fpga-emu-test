PCF_FILE        =  test.pcf
VCD_FILE 		    =  build/test.vcd
SBY_FILE 		    =  formal/test.sby
SYNTH_V_SRCS    =  rtl/dual_priority_encoder.v rtl/priority_encoder.v
SYNTH_TOP_MODULE=  dual_priority_encoder


YOSYS_FLAGS     =  -p 'synth_ice40 -json $(OUTPUT_JSON)'
NEXTPNR_FLAGS   =  --hx8k --package ct256 --pcf-allow-unconstrained

SYNTH_BUILD_DIR =  synth_build
OUTPUT_ASC      =  $(SYNTH_BUILD_DIR)/test.asc
OUTPUT_JSON     =  $(SYNTH_BUILD_DIR)/test.json
OUTPUT_BIN      =  $(SYNTH_BUILD_DIR)/test.bin

clean:
	rm -rf $(SYNTH_BUILD_DIR)

synth: $(SYNTH_V_SRCS)
	mkdir -p $(SYNTH_BUILD_DIR)
	yosys $(YOSYS_FLAGS) $(SYNTH_V_SRCS)
	nextpnr-ice40 $(NEXTPNR_FLAGS) --top $(SYNTH_TOP_MODULE) --pcf $(PCF_FILE) --json $(OUTPUT_JSON) --asc $(OUTPUT_ASC) 
	icepack $(OUTPUT_ASC) $(OUTPUT_BIN)

view_vcd:
	gtkwave $(VCD_FILE)

verify: 
	sby -f $(SBY_FILE)