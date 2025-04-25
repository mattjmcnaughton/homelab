# !/usr/bin/env bash

ollama serve &
ollama_serve_pid=$!

ollama list
ollama pull nomic-embed-text

kill $ollama_serve_pid
