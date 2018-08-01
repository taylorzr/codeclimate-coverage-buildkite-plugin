# Codeclimate Coverage Buildkite Plugin

This is a [Buildkite plugin](https://buildkite.com/docs/agent/v3/plugins) for Codeclimate coverage
reporting. It adds pre-command and post-command hooks that use [Codeclimate's test
reporter](https://github.com/codeclimate/test-reporter) to submit code coverage reports to
Codeclimate.

To use this plugin you need to:
- Setup a code coverage tool for your project. For example, if you're working on a Ruby/Rails
  project, you can use [SimpleCov](https://github.com/colszowka/simplecov).
- Setup a Codeclimate account, and add your repository to Codeclimate
- Get the test reporter id for your repo (https://docs.codeclimate.com/docs/finding-your-test-coverage-token), and set it as the env var CC_TEST_REPORTER_ID on your Buildkite pipeline

Then configure your buildkite pipeline for parallel or non-parallel test steps:

## Non-Parallel
1. Add codeclimate-coverage plugin to your test step.

You're test step should look something like this:

```yml
- name: 'Test'
  command: '.buildkite/test'
  plugins:
    docker-compose#v2.4.1:
      run: web
      env:
        # Used by code coverage
        - BUILDKITE_BRANCH
        - BUILDKITE_COMMIT
        - CC_TEST_REPORTER_ID
    taylorzr/codeclimate-coverage#v0.1.0: ~

```

## Parallel
1. Add coverage to your artifact_paths
2. Add codeclimate-coverage plugin to your test step
3. Add a new step to sum and upload the aggregate coverage report


You're pipeline should look something like this:

```yml
  - name: 'Test'
    command: '.buildkite/test'
    artifact_paths:
      - "coverage/codeclimate_coverage_*.json"
    parallelism: 2
    plugins:
      docker-compose#v2.4.1:
        run: web
        env:
          # Used by code coverage
          - BUILDKITE_BRANCH
          - BUILDKITE_COMMIT
          - CC_TEST_REPORTER_ID
      taylorzr/codeclimate-coverage#v0.1.0:
        prefix: '/usr/src/app'

  - name: ':codeclimate: Upload'
    command: 'echo +++ :codeclimate:'
    plugins:
      taylorzr/codeclimate-coverage#v0.1.0: ~
        sum_and_upload: true
        prefix: '/usr/src/app'
```

## TODO:
- document, explain, and test prefix config
- document and test reporter url config
- document debug config
- document caveats
  - must mount local dir when using docker-compose
  - must pass through env variables
