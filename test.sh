#!/bin/bash

script_dir=$(dirname "$0")

if [ $# -eq 0 ]; then
  build_type="Debug"
else
  build_type=$1
fi

build_dir=$script_dir/$build_type

tests=$build_dir/bin/tests

TEST_RESULTS="${TEST_RESULTS:-$build_dir}/"

./$script_dir/build.sh $build_type && \
  ./$tests --gtest_output=xml:$TEST_RESULTS
