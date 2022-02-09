#!/bin/bash

# This script executes the program being experimented.
#
# $1 - The job to execute.
# $2 - The output directory.

# Setting up the environment.
dir=$(dirname $0)
export PATH="$PATH:$dir/../tools"

# Running the solver on the input.
$dir/scip/scip -c "read $1" -c "set lp resolvealgorithm c" -c optimize
