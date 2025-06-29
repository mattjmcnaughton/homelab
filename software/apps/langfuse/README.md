# langfuse

Experimenting w/ langfuse as a prompt manager.

## Configuring Homelab

After deploying via `ansible`, we perform the following manual configuration.

1. Sign Up for a User Account
2. Create an organization called `homelab`.
3. Create a project within that organization called `main`.
4. Via the "Playground" tab, add a new LLM API key from LiteLLM. It should be
   labelled `langfuse-homelab-main-playground`.
5. Organize prompts.
    - `user` is for `user` prompts and `system` is for system prompts.
