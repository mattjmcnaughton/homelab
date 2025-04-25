# Roadmap

- ai
    - Add the following to LiteLLM:
        - Perplexity AI
        - OpenAI (i.e. ChatGPT)
    - AWS Bedrock
        - Document how AWS_SESSION_TOKEN is used and what it's sensitivity is.
        - Document the models to which we needed to request access.
    - Add traefik proxy
        - Use https://github.com/hectorm/docker-proxy
            - MIT licenses
            - Can fully validate code and pin to specific version.
    - Assistants
        - Configure Assistants via LiteLLM
            - https://docs.litellm.ai/docs/assistants#quick-start
        - Configure Assistants via LibreChat (?)
            - https://www.librechat.ai/docs/configuration/librechat_yaml/object_structure/assistants_endpoint
            - https://www.librechat.ai/docs/configuration/pre_configured_ai/assistants
                - Specify `ASSISTANTS_BASE_URL`
    - MCP
        - Enable MCPs in LibreChat (or maybe LiteLLM ... tbd)
            - https://www.librechat.ai/docs/configuration/librechat_yaml/object_structure/mcp_servers
        - Enable MCPs
            - Primary
                - https://github.com/modelcontextprotocol/servers/tree/main/src/filesystem
            - Secondary
                - https://github.com/modelcontextprotocol/servers/tree/main/src/git
                - https://github.com/modelcontextprotocol/servers/tree/main/src/fetch
                - https://github.com/modelcontextprotocol/servers/tree/main/src/sequentialthinking
                - https://github.com/ppl-ai/modelcontextprotocol
                - https://github.com/MarkusPfundstein/mcp-obsidian
                - https://github.com/alioshr/memory-bank-mcp
                - https://github.com/nickclyde/duckduckgo-mcp-server
    - Configure Agents and/or Assistants and/or Presets for my different
      personas.
        - python-sme
        - devops-sme
        - ...
    - tbd: Research script for managing LibreChat custom instructions (i.e. system prompt), personas, etc...
      via source control (i.e. LibreChat LLM).
    - tbd: experiment w/ Open Webui

- dev
    - workspace
        - ubuntu:25.04
            - build/workspace/Dockerfile (can base on toolbox-vim)
                - Install just, curl, wget, tmux, git, ripgrep
                - Install neovim 0.11
                - Install uv, npm, cargo
                - Install language servers (i.e. pyright, ruff-lsp)
                - Configure tmux
                - Configure Neovim
                    - Plugins
                        - LazyVim for plugin management
                        - treesitter
                        - telescope
                        - nvim-cmp
                        - obsidian (only if given a dir as environment variable)
                        - LSPs
                    - Configuration
                        - Default
                        - Language
                            - Python
                            - Yaml
                            - Bash
                            - Dockerfile
                            - Makefile
                            - Lua
                    - Write the `nvim-simple-ai` plugin for Vim chats w/
                      litellm.
                        - Or see if there's a suitable existing one given that
                          we're airgapped.
    - claude-code-container

- overall
    - Should local-code and local-ai be one project or two?
    - Sample `compose.yaml` for "dropping" into project
    - Add additional security_opt and think about how manage shared
      volumes/networks (i.e. if we have multiple instances running)
    - Lightweight binary for managing everything
