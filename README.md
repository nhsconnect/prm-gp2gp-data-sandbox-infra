# prm-gp2gp-data-sandbox-infra

This repo contains infrastructure code for provisioning AWS resources that support exploratory GP2GP data analytics.

## Setup

These instructions assume you are using:

- [aws-vault](https://github.com/99designs/aws-vault) to validate your aws credentials.
- [dojo](https://github.com/kudulab/dojo) to provide an execution environment

## Applying terraform

Rolling out terraform against each environment is managed by the GoCD pipeline.
If you'd like to test it locally, run the following commands:

1. Enter the container:

`aws-vault exec <profile-name> -- dojo`

2. Invoke terraform:

```
  ./tasks validate <stack-name> <environment>
  ./tasks plan <stack-name> <environment>
```

For example:

```
  ./tasks validate notebooks dev
  ./tasks plan notebooks dev
```
