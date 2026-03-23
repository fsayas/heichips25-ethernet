SIM ?= icarus
TOPLEVEL_LANG ?= verilog

VERILOG_SOURCES += $(PWD)/../src/phy.v
VERILOG_SOURCES += $(PWD)/../src/mdio.v
# VERILOG_SOURCES += $(PWD)/../src/line_driver.v

TOPLEVEL = phy
MODULE = test_phy

include $(shell cocotb-config --makefiles)/Makefile.sim
