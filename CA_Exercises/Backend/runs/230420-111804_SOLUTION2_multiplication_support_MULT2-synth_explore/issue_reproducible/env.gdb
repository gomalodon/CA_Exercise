set env CARRY_SELECT_ADDER_MAP pdk/sky130A/libs.tech/openlane/sky130_fd_sc_hd/csa_map.v
set env CLOCK_PERIOD 100
set env DESIGN_NAME cpu
set env EXTRA_LIBS OpenRAM_output/sky130_sram_2rw_64x128_64_TT_1p8V_25C.lib OpenRAM_output/sky130_sram_2rw_32x128_32_TT_1p8V_25C.lib
set env FULL_ADDER_MAP pdk/sky130A/libs.tech/openlane/sky130_fd_sc_hd/fa_map.v
set env LIB_SYNTH ./tmp/synthesis/trimmed.lib
set env LIB_SYNTH_COMPLETE_NO_PG ./tmp/synthesis/0-sky130_fd_sc_hd__tt_025C_1v80.no_pg.lib
set env LIB_SYNTH_NO_PG ./tmp/synthesis/0-trimmed.no_pg.lib
set env PACKAGED_SCRIPT_0 users/students/r0790882/Desktop/CA_Exercise/CA_Exercises/Backend/conda-env/share/openlane/scripts/yosys/synth.tcl
set env PACKAGED_SCRIPT_1 ./tmp/synthesis/synthesis.sdc
set env RIPPLE_CARRY_ADDER_MAP pdk/sky130A/libs.tech/openlane/sky130_fd_sc_hd/rca_map.v
set env SAVE_NETLIST ./results/synthesis/cpu.v
set env SYNTH_ADDER_TYPE YOSYS
set env SYNTH_BUFFERING 1
set env SYNTH_CAP_LOAD 33.442
set env SYNTH_DRIVING_CELL sky130_fd_sc_hd__inv_2
set env SYNTH_EXPLORE 1
set env SYNTH_EXTRA_MAPPING_FILE 
set env SYNTH_LATCH_MAP pdk/sky130A/libs.tech/openlane/sky130_fd_sc_hd/latch_map.v
set env SYNTH_MAX_FANOUT 30
set env SYNTH_MAX_TRAN 0.75
set env SYNTH_MIN_BUF_PORT sky130_fd_sc_hd__buf_2 A X
set env SYNTH_NO_FLAT 0
set env SYNTH_READ_BLACKBOX_LIB 0
set env SYNTH_SHARE_RESOURCES 1
set env SYNTH_SIZING 0
set env SYNTH_STRATEGY AREA 0
set env SYNTH_TIEHI_PORT sky130_fd_sc_hd__conb_1 HI
set env SYNTH_TIELO_PORT sky130_fd_sc_hd__conb_1 LO
set env TRISTATE_BUFFER_MAP pdk/sky130A/libs.tech/openlane/sky130_fd_sc_hd/tribuff_map.v
set env VERILOG_FILES ../Verilog/RTL_SOLUTION2_multiplication_support_MULT2/*.v
set env synth_report_prefix ./reports/synthesis/0-synthesis
set env synthesis_results ./results/synthesis
set env synthesis_tmpfiles ./tmp/synthesis