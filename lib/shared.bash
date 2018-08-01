#!/usr/bin/env bash

function install_test_reporter() {
  if [ -f ./cc-test-reporter ]; then
    echo "--- :codeclimate: Using existing Codeclimate reporter"
  else
    echo "--- :codeclimate: Installing Codeclimate reporter"
    test_reporter_url="${BUILDKITE_PLUGIN_CODECLIMATE_COVERAGE_TEST_REPORTER_URL:-https://codeclimate.com/downloads/test-reporter/test-reporter-latest-linux-amd64}"
    curl -L "$test_reporter_url" > ./cc-test-reporter
    chmod +x ./cc-test-reporter
  fi
}

install_test_reporter
