#!/bin/bash
pkill redis-server

# Wait for a moment to ensure the process is terminated
sleep 2

# Generate a timestamp
TIMESTAMP=$(date +"%Y%m%d%H%M%S")
lcov --capture --directory /usr/src/FalkorDB --output-file /${TIMESTAMP}.info --rc geninfo_unexecuted_blocks=1 --rc lcov_branch_coverage=1 --ignore-errors mismatch --ignore-errors negative