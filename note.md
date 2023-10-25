TIMESTAMP=$(date +"%Y%m%d%H%M%S")
lcov --capture --directory . --output-file /${TIMESTAMP}.info --rc geninfo_unexecuted_blocks=1 --rc lcov_branch_coverage=1 --ignore-errors mismatch --ignore-errors negative
genhtml /coverage.info --output-directory /out