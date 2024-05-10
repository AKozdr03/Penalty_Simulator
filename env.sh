#!/bin/bash -e
#
# Copyright (C) 2023  AGH University of Science and Technology
# MTM UEC2
# Author: Piotr Kaczmarczyk
#
# Description:
# Initialize enviorment for working with the project.

export ROOT_DIR=$(pwd)
export PATH=tools:${PATH}
export VIVADO_DIR=$(which vivado | sed "s/bin\/vivado//")

# Create local git repository - required for scripts
if [[ ! -d .git ]]; then
    git init
    git add .
fi

# Copy glbl.v from Vivado instalation dir - required for IP simulation
if [[ ! -e sim/common/glbl.v ]]; then
    mkdir -p sim/common
    cp ${VIVADO_DIR}/data/verilog/src/glbl.v sim/common/glbl.v
fi
