# open-webui

## Metadata

status: Deployed --> MVP
url: https://open-webui.capybara-tuna.ts.net
deployment-strategy: ansible-docker-compose-ec2

## Local testing

Should be straightforward to test locally, with the following exceptions:

- Will need to create a `.env.tailscale` (from the `.env.tailscale.j2`
  template) with the proper Oauth Client Secret.
- We need to ensure Amazon Bedrock Access Gateway has the proper permissions (if
  we want to be able use models on Bedrock).

## TODO

### MVP

- Configure `bedrock-access-gateway`
    - https://jrpospos.blog/posts/2024/08/using-amazon-bedrock-with-openwebui-when-working-with-sensitive-data/
- Switch to using Postgres as database
- Basic configuration (i.e. set-up personas, etc)
- Add ChatAPI key (and optionally delete ChatAPI pro subscription)
    - See if possible to configure/simulate the "Deep Research" option.

### One-day

- Experiment w/ ollama-gpu for true self-hosting of models.
- Migrate sidecar Postgres database to our centralized Postgres cluster (once we've set
  that up).
- Configuration backup strategy
