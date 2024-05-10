#!/bin/bash
#
# Copyright (C) 2023  AGH University of Science and Technology
# MTM UEC2
# Author: Piotr Kaczmarczyk
#
# Description:
# This script runs simulations outside Vivado, making them faster.
# For usage details run the script with no arguments.
# For more information see: AMD Xilinx UG 900:
# https://docs.xilinx.com/r/en-US/ug900-vivado-logic-simulation/Simulating-in-Batch-or-Scripted-Mode-in-Vivado-Simulator
# To work properly, a git repository in the project directory is required.
# Run from the project root directory.

# ------------------------------------------------------------------------------
# Functions
# ------------------------------------------------------------------------------

function usage {
    echo "usage: $(basename "$0") [options]"
    echo "  options:"
    echo "    -l         list available tests"
    echo "    -t <test>  run the specified <test>"
    echo "    -g         show gui (use with -t)"
    echo "    -a         run all available tests (does not work with gui)"
    exit 1
}

function list_available_tests {
    ls -1 --ignore 'build' --ignore 'common' --ignore '*.*' .
    exit 0
}

function execute_test {
    # Remove untracked files
    git clean -fXd .

    mkdir -p build
    cd build

    test_name=$1

    # Elaboration and simulation options
    if [[ $(grep 'glbl.v' -oc  ${ROOT_DIR}/sim/${test_name}/${test_name}.prj) -gt 0 ]]; then
        COMPILE_GLBL='work.glbl'
    else
        COMPILE_GLBL=''
    fi

    XELAB_OPTS="work.${test_name}_tb
                ${COMPILE_GLBL}
                -snapshot ${test_name}_tb
                -prj ${ROOT_DIR}/sim/${test_name}/${test_name}.prj
                -timescale 1ns/1ps
                -L unisims_ver"

    # Run simulation
    if [[ ${show_gui} ]]; then
        xelab ${XELAB_OPTS} -debug typical
        xsim ${test_name}_tb -gui -t ${ROOT_DIR}/tools/sim_cmd.tcl
    else
        xelab ${XELAB_OPTS} -standalone -runall \
        | grep -ie '^\|fatal:\|error:\|critical\|warning:' --color=always
    fi

    cd ..
}

# Run all available simulations
function run_all {
    for test in $(list_available_tests); do
        err_ctr=0
        echo -en "${test}:\t"
        err_ctr=$(execute_test ${test} | grep -oic 'error')
        if [ $err_ctr == 0 ]; then
            echo -e "\033[1;32m PASSED\033[0;39m"
        else
            echo -e "\033[1;31m FAILED\033[0;39m"
        fi
    done
    exit 0
}

# ------------------------------------------------------------------------------
# Arguments parsing and checking
# ------------------------------------------------------------------------------

if [[ $# -eq 0 ]]; then
    usage
fi

cd sim

while getopts aglrs:t: option; do
    case ${option} in
        g) show_gui=1;;
        l) list_available_tests;;
        t) test_name=${OPTARG};;
        a) run_all;;
        *) usage;;
    esac
done

if [[ ${test_name} ]]; then
    execute_test ${test_name}
fi
