# bootstrap

Bootstrap a Terraform/OpenTofu environment.

We create an S3 bucket for state management and DynamoDB table for
state locking.

## Usage

```
# See script for overwriting Env variables for custom bucket/ddb names.
./terraform-remote-bootstrap.sh
```

Command is a no-op if resources already exist.

## Audit Log

- Last ran on 2025-03-15 to configure initial bucket/ddb.
