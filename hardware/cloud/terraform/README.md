# terraform

## Organization

- bootstrap
    - Responsible for bootstrapping state management via a shell script.
- environments
    - Responsible for provisioning/managing cloud infrastructure in the
      prod/dev/global accounts. In general, we strive to keep prod/dev as
      isolated as possibe (meaning our `global` environment should be minimal).
    - We use separate VPCs for dev/prod/global. However, we use the same AWS
      account.
- modules
    - Terraform modules utilized in the different environments.

## Tooling

- Use OpenTofu, managed via `tenv`.
    - Version managed via `.opentofu-version` file.
- Manage Terraform state in S3 bucket created via the `bootstrap` repo.
  Coordinate workspace locking via DynamoDB table created via the `bootstrap`
  repo. We share one bucket/DDB table across all environments.
