# code-local

A local, secure, containerized AI development environment powered by LibreChat,
LiteLLM, and Ollama.

## Features

- **LibreChat UI**: Web interface for interacting with AI models (accessible at http://localhost:3080)
- **LiteLLM**: Unified API interface to multiple LLM providers (accessible at http://localhost:4000)
- **Ollama**: Local embedding models for RAG capabilities (accessible at http://localhost:11434)
- **RAG Support**: Vector database with pgvector for document retrieval and embedding
- **Security**: Runs with reduced privileges, capability restrictions, and resource limits. (Coming soon) Limits egrees via Traefik proxy.
- **Developer Tools**: (Coming soon) Dev workspace container containing neovim, claude-code workspace

## Supported Models

- Anthropic Claude 3.7 Sonnet
- Bedrock models:
  - Amazon Titan Text Premier
  - Llama 3 70B Instruct
  - Mistral 7B Instruct

## Run

Ensure that the proper `AWS_*` environment variables are in the shell...

`docker compose --env-file .env --env-file .env.secret up --build -d`

## Getting Started

- `cp .env.secret.sample .env.secret` and update w/ appropriate secrets.
- `docker compose --env-file .env --env-file .env.secret up --build -d`
- In LiteLLM Admin UI:
    - Create personal Team in LiteLLM, giving access to all models.
    - Create `mattjmcnaughton` API key, belonging to `personal` team.
        - Give access to all Team models.
- Copy key to `LIBRECHAT_LITELLM_API_KEY` in `.env`.
- `docker compose down librechat && docker compose up librechat`

## Roadmap

See [ROADMAP.md](ROADMAP.md).
