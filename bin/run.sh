#!/usr/bin/env bash

# Synopsis:
# Run the test runner on a solution.

# Arguments:
# $1: exercise slug
# $2: absolute path to solution folder
# $3: absolute path to output directory

# Output:
# Writes the test results to a results.json file in the passed-in output directory.
# The test results are formatted according to the specifications at https://github.com/exercism/docs/blob/main/building/tooling/test-runners/interface.md

# Example:
# ./bin/run.sh two-fer /absolute/path/to/two-fer/solution/folder/ /absolute/path/to/output/directory/

# If any required argument is missing, print the usage and exit.
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
    echo "usage: ./bin/run.sh exercise-slug /absolute/path/to/two-fer/solution/folder/ /absolute/path/to/output/directory/"
    exit 1
fi

slug="$1"
input_dir="${2%/}"
output_dir="${3%/}"
exercise="${slug//-/_}"
implementation_file="${input_dir}/${exercise}.vim"
tests_file="${input_dir}/${exercise}.vader"
results_file="${output_dir}/results.json"

mkdir -p "${output_dir}"

echo "${slug}: testing..."
vim -Nu NONE -i NONE -n -es -S lib/runner.vim -- \
    "${implementation_file}" "${tests_file}" "${results_file}" "${input_dir}" /opt/vader.vim

if [ ! -s "${results_file}" ]; then
    jq -n '{version: 2, status: "error", message: "The Vim test runner could not start. Please start a thread on the Exercism forums.", tests: []}' > "${results_file}"
fi

echo "${slug}: done"
