#!/usr/bin/env bats

load "$BATS_PATH/load.bash"

@test "pre-command calls cc-test-reporter before-build" {
  stub curl "-L https://codeclimate.com/downloads/test-reporter/test-reporter-latest-linux-amd64 : cp tests/fake-cc-test-reporter cc-test-reporter"

  run $PWD/hooks/pre-command

  assert_output --partial "fake-cc-test-reporter called with before-build"
  assert_success

  rm ./cc-test-reporter
}
