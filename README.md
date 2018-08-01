# Codeclimate Coverage Buildkite Plugin
# TODO: Why would you use this
# TODO: What this does

## Sequential
1. Set CC_TEST_REPORTER_ID
2. Append artifact_paths
3. Add codeclimate-coverage plugin to your test step

```yml
- name: 'Test'
  command: '.buildkite/test'
  artifact_paths:
    - "coverage/codeclimate_coverage_*.json"
  plugins:
    docker-compose#v2.4.1:
      run: web
      env:
        # Used by code coverage
        - BUILDKITE_BRANCH
        - BUILDKITE_COMMIT
        - CC_TEST_REPORTER_ID
    taylorzr/codeclimate-coverage#master: ~

```


## Parallel
1. Set CC_TEST_REPORTER_ID
2. Append artifact_paths
3. Add codeclimate-coverage plugin to your test step
4. Add a new step to join and upload the aggregate coverage report

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
      codeclimate-coverage: ~

  - name: ':codeclimate: Upload'
    command: 'echo +++ :codeclimate:'
    plugins:
      taylorzr/codeclimate-coverage#master: ~
        sum_and_upload: true
```
