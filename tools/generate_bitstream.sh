#!/bin/bash
#
# Copyright (C) 2023  AGH University of Science and Technology
# MTM UEC2
# Author: Piotr Kaczmarczyk
#
# Description:
# This script runs Vivado in tcl mode and sources an apropriate tcl file to run
# all the steps to generate bitstream. When finished, the bitsream is copied to
# the result directory. Additionally, all the warnings and errors logged during
# synthesis and implementation are also copied to results/warning_summary.log
# To work properly, a git repository in the project directory is required.
# Run from the project root directory.

# Remove untracked files
git clean -fXd fpga

# Run Vivado and generate bitstream
cd fpga
vivado -mode tcl -source scripts/generate_bitstream.tcl
cd ${ROOT_DIR}

# Copy bitstream to results
find fpga/build -name "*.bit" -exec cp {} results/ \;

# Copy warnings and errors to a single log file in results
./tools/warning_summary.sh
