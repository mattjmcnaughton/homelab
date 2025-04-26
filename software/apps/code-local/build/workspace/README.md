# workspace

## Development Workspace

A containerized development environment with Neovim, tmux, and essential development tools.

## Overview

This workspace provides a consistent, reproducible development environment based on Ubuntu 25.04 with Neovim 0.11 as the primary editor.

It includes language servers, linting tools, and a comprehensive plugin ecosystem optimized for Python, Go, Lua, and Rust development.

## Features

- Neovim 0.11 with LSP integration and modern plugins
- tmux for terminal session management

## Development Tools:

- Python 3.12 with uv package manager
- Node.js 22.15
- Go 1.24
- Rust via rustup
- Git

## Pre-configured LSP Support

- Python: ruff-lsp for linting, pyright for type checking
- Go: gopls for completion and analysis
- Lua: lua-language-server for Neovim plugin development

Additional Languages: Support via Treesitter for JS/TS, Rust, Bash, JSON, YAML, etc.

## Neovim Plugin Highlights

- folke/snacks.nvim: All-in-one UI and navigation experience and finder/picker (replacing telescope)
- folke/trouble.nvim: Pretty diagnostics, references, and locations
- folke/tokyonight.nvim: Clean, dark theme with vibrant colors
- Treesitter: Enhanced syntax highlighting
- Blink.cmp: Intelligent code completion
- Obsidian.nvim: Integration with Obsidian vaults (when enabled via environment)

## Usage

Building the Container

```
docker build -t $IMAGE_TAG .
```

Running the Container

```
docker run -it --rm \
  -v /path/to/your/code:/workspace \
  -e OBSIDIAN_VAULT_DIR=/path/to/obsidian/vault \  # Optional
  dev-workspace
```

## Notes

- The container runs as a non-root user (mattjmcnaughton).
- Plugin installations are performed at build time so we can air-gap this development environment.
