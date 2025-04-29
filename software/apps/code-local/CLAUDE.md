# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Code Style Guidelines
- Use Docker best practices for container definitions
- Follow variable naming in compose.yaml: UPPERCASE for environment variables
- Security first: always use non-root users, capability drops, and resource limits
- Keep services isolated in the private network
- Document any changes to security configurations
- Maintain the existing project structure with build components in the build/ directory
- Use Justfile for defining convenience commands
- Commit messages should follow Conventional Commits format (type: description)
- Format commit message body with bullet points for changes
- Follow the current formatting style in each file
