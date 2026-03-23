#!/bin/bash

# Exit script if any command fails
set -e

echo "Compiling PHY design..."
iverilog -o phy_tb.vvp ../src/phy.v ../src/mdio.v phy_tb.sv

echo "Running simulation..."
vvp phy_tb.vvp

echo "Simulation complete! Waveforms saved to phy_tb.vcd."

# Check if gtkwave argument is passed
if [ "$1" == "--gui" ] || [ "$1" == "-g" ]; then
    echo "Opening GTKWave..."
    gtkwave phy_tb.vcd &
else
    echo "Run with '--gui' to automatically open GTKWave."
fi
