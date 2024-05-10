#!/bin/bash
#
# Copyright (C) 2023  AGH University of Science and Technology
# MTM UEC2
# Author: Piotr Kaczmarczyk
#
# Description:
# Remove untracked files from the project
# To work properly, a git repository in the project directory is required.
# Run from the project root directory.

git clean -fdX
