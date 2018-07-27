#!/usr/bin/env bats

load "$BATS_PATH/load.bash"

@test "post-command submits coverage when run in non-parallel step" {
  export BUILDKITE_COMMAND_EXIT_STATUS=42

  cp tests/fake-cc-test-reporter cc-test-reporter
  chmod +x cc-test-reporter

  run $PWD/hooks/post-command

  assert_output --partial 'fake-cc-test-reporter called with after-build --exit-code 42 --prefix /workdir --debug'
  assert_success

  rm ./cc-test-reporter
  rm -rf coverage/
}

@test "post-command formats coverage when run in parallel step" {
  export BUILDKITE_COMMAND_EXIT_STATUS=42
  export BUILDKITE_PARALLEL_JOB=2

  cp tests/fake-cc-test-reporter cc-test-reporter
  chmod +x cc-test-reporter

  run $PWD/hooks/post-command

  assert_output --partial 'fake-cc-test-reporter called with format-coverage --output coverage/codeclimate_2.json --prefix /workdir'
  assert_success

  rm ./cc-test-reporter
}

@test "post-command sums and uploads when sum_and_upload=true" {
  export BUILDKITE_COMMAND_EXIT_STATUS=42
  export BUILDKITE_PARALLEL_JOB=2
  export BUILDKITE_PLUGIN_CODECLIMATE_COVERAGE_SUM_AND_UPLOAD=true

  cp tests/fake-cc-test-reporter cc-test-reporter
  chmod +x cc-test-reporter

  stub buildkite-agent "artifact download coverage/* coverage/ : echo hi"

  run $PWD/hooks/post-command

  assert_output --partial 'fake-cc-test-reporter called with sum-coverage --output coverage/codeclimate_coverage_aggregate.json coverage/codeclimate_*.json'
  assert_success

  rm ./cc-test-reporter
  rm -rf coverage/
}
