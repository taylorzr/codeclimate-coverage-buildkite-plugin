#!/usr/bin/env bats

load "$BATS_PATH/load.bash"

@test "pre-command calls cc-test-reporter before-build" {
  cp tests/fake-cc-test-reporter cc-test-reporter
  chmod +x cc-test-reporter

  run $PWD/hooks/pre-command

  assert_output --partial "fake-cc-test-reporter called with before-build"
  assert_success

  rm ./cc-test-reporter
}

@test "pre-command uses debug flag when debug=true" {
  cp tests/fake-cc-test-reporter cc-test-reporter
  chmod +x cc-test-reporter

  export BUILDKITE_PLUGIN_CODECLIMATE_COVERAGE_DEBUG=true

  run $PWD/hooks/pre-command

  assert_output --partial "fake-cc-test-reporter called with before-build --debug"
  assert_success

  rm ./cc-test-reporter
}

@test "pre-command uses existing cc-test-reporter" {
  cp tests/fake-cc-test-reporter cc-test-reporter
  chmod +x cc-test-reporter

  run $PWD/hooks/pre-command

  assert_output --partial "fake-cc-test-reporter called with before-build"
  assert_output --partial "--- :codeclimate: Using existing Codeclimate reporter"
  assert_success

  rm ./cc-test-reporter
}

@test "pre-command installs cc-test-reporter when it doesn't exist" {
  stub curl "-L https://codeclimate.com/downloads/test-reporter/test-reporter-latest-linux-amd64 : cp tests/fake-cc-test-reporter cc-test-reporter"

  run $PWD/hooks/pre-command

  assert_output --partial "fake-cc-test-reporter called with before-build"
  assert_output --partial "--- :codeclimate: Installing Codeclimate reporter"
  assert_success

  rm ./cc-test-reporter
}
