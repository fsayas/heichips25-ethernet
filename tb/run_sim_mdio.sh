#!/bin/bash

# Exit script if any command fails
set -e

echo "Compiling MDIO design..."
iverilog -o mdio_tb.vvp ../src/mdio.v mdio_tb.sv

echo "Running simulation..."
vvp mdio_tb.vvp

echo "Simulation complete! Waveforms saved to mdio_tb.vcd."

# Check if gtkwave argument is passed
if [ "$1" == "--gui" ] || [ "$1" == "-g" ]; then
    echo "Opening GTKWave..."
    gtkwave mdio_tb.vcd &
else
    echo "Run with '--gui' to automatically open GTKWave."
fi
