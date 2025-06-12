
# Makefile for Asynchronous FIFO Vivado Flow

VIVADO := /home/roy/NewFolder.1/Vivado/2024.2/bin/vivado
#VIVADO := vivado
TCL_SCRIPT := scripts/run_vivado.tcl

.PHONY: all synth clean

all: synth

synth:
	$(VIVADO) -mode batch -source $(TCL_SCRIPT)

clean:
	rm -rf vivado_project *.jou *.log

