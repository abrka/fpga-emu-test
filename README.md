# FPGA EMU Test

## Description 
This is fpga emulator(?)

## Requirements
- ncurses
### For viewing waveforms
- gtkwave 
### For simulating with iverilog
- iverilog
### For simulating with verilator
- verilator
### For synthesizing for lattice ice40 fpgas
- yosys
- nextpnr-ice40
- icepack

## Usage

### Synthesize for lattice ic40 fpgas
```sh
make synth
```

### Simulate using iverilog

```sh
make sim
```

### View VCD file
```sh
make view_vcd
```

### Simulate using verilator

```sh 
mkdir build
cd build
cmake ..
cmake --build .
./verilator_test
```
