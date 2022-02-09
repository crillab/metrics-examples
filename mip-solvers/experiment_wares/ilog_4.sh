#!/bin/bash

# This script executes the program being experimented.
#
# $1 - The job to execute.
# $2 - The output directory.

# Setting up the environment.
dir=$(dirname $0)
export PATH="$PATH:$dir/../tools"

# Running the solver on the input.
$dir/ilog/cplex/bin/x86-64_linux/cplex -c "read $1" "set lpmethod 4" optimize
