# ROADMAP

## v0.0.1

### General

- org: Extract local-ai and local-workspace into separate repos, with guidance for
  how they can interact over 1) tailscale or 2) an internal docker network.

### local-ai

- feat: Run open-webui
    - Backed by DB.
    - RAG
    - Uses LiteLLM
- chore: AWS Bedrock
    - Document how AWS_SESSION_TOKEN is used and what it's sensitivity is. Do we
      care that it's logged in LiteLLM?
    - Document the models to which we needed to request access.
    - Lightweight documentation for `claude code` w/ Bedrock (theoretical).
- feat: Add traefik proxy
    - Include infra diagram outlining the three diff networks:
        - limited-internal: vim, librechat, open-webui
            - Only internal (i.e. litellm).
        - limited-public: LiteLlm, Claude
            - Allowlist of public domains.
        - proxy: Traefik
    - Use https://github.com/hectorm/docker-proxy
        - MIT licenses
        - Can fully validate code and pin to specific version.
    - Test working as expected.
- chore: Identify/document strategy for "sandboxing" network for Open Webui/LibreChat
  browers.
- feat: MVP `local-ai` on docker-compose/tailscale for Homelab
    - Don't worry about Ansible, etc... although we can put `compose.yaml` in
      source control. Assuming goes well, we will move to EKS. We're using DBs
      (in docker volumes), so we will retain the interesting data.

### local-workspace

Feature complete (at least w.r.t. major features) for v0.0.1!

## v0.1.0

### local-ai

- bug: Fix `claude-code` so that it doesn't require fetching an Anthropic API
  key (that it will never use) on boot.
    - I _think_ we want to look into the `apiKeyHelper` script, but tbd.
- feat: Add the following to LiteLLM (obtaining API keys if necessary):
    - Perplexity
    - OpenAI (i.e. ChatGPT)
    - tbd: image generation
- feat: Experiment w/ Assistants in LibreChat/OpenWebui and/or LibreChat
    - https://docs.litellm.ai/docs/assistants#quick-start
    - https://www.librechat.ai/docs/configuration/librechat_yaml/object_structure/assistants_endpoint
    - https://www.librechat.ai/docs/configuration/pre_configured_ai/assistants
- feat: MCP
    - Enable MCPs
        - Decide _where_ this configuration should live (LibreChat/OpenWebui vs
          LiteLLM)
            - Should they run via stdin or over the network?
        - Primary
            - https://github.com/modelcontextprotocol/servers/tree/main/src/filesystem
        - Secondary
            - https://github.com/modelcontextprotocol/servers/tree/main/src/git
            - https://github.com/modelcontextprotocol/servers/tree/main/src/fetch
            - https://github.com/modelcontextprotocol/servers/tree/main/src/sequentialthinking
            - https://github.com/ppl-ai/modelcontextprotocol
            - https://github.com/MarkusPfundstein/mcp-obsidian
            - https://github.com/nickclyde/duckduckgo-mcp-server
            - https://github.com/alioshr/memory-bank-mcp
- feat: Configure Agents and/or Assistants and/or Presets for my different
  personas. Strategy for how to manage in a centralized location.
    - python-sme
    - devops-sme
    - ...
- feat: `local-ai` on EKS (and run production `local-ai` on Homelab)

### local-workspace

- feat: experiment w/ `llm.nvim` and `llm-ls` from Huggingface.
- feat: Intelligently create the `compose.yaml` for a project (perhaps via binary)?
