FROM docker.io/ubuntu:25.04

ARG USERNAME=mattjmcnaughton
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create nonroot user
RUN userdel -r ubuntu
RUN groupadd --gid $USER_GID $USERNAME && \
   useradd --uid $USER_UID --gid $USER_GID -m $USERNAME

ENV DEBIAN_FRONTEND=noninteractive

# Install base packages
RUN apt update && apt install -y build-essential \
  curl \
  dnsutils \
  gettext \
  git \
  gzip \
  iputils-ping \
  just \
  lsof \
  ripgrep \
  tar \
  tmux \
  tree \
  unzip \
  wget \
  xz-utils

# Install apt packages to use w/ telescope-nvim
RUN apt install -y cmake fzf ripgrep fd-find

# Download and install Neovim v0.11.1
ENV NEOVIM_VERSION=v0.11.1
RUN wget https://github.com/neovim/neovim/releases/download/$NEOVIM_VERSION/nvim-linux-x86_64.tar.gz \
    && tar xzvf nvim-linux-x86_64.tar.gz \
    && cp -r nvim-linux-x86_64/* /usr/local/ \
    && rm -rf /tmp/neovim

# Install specific Node.js version using binaries
# Choose your desired version from https://nodejs.org/dist/
ENV NODE_VERSION=v22.15.0

RUN wget https://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}-linux-x64.tar.xz \
    && mkdir -p /usr/local/lib/nodejs \
    && tar -xJf node-${NODE_VERSION}-linux-x64.tar.xz -C /usr/local/lib/nodejs \
    && rm node-${NODE_VERSION}-linux-x64.tar.xz
ENV PATH=/usr/local/lib/nodejs/node-${NODE_VERSION}-linux-x64/bin:$PATH

# Install rustup (to use w/ rust)
RUN apt install -y rustup

# Install golang
ENV GO_VERSION=1.24.1
RUN wget https://golang.org/dl/go$GO_VERSION.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go$GO_VERSION.linux-amd64.tar.gz
ENV PATH=$PATH:/usr/local/go/bin

# Install uv
ENV UV_VERSION=0.6.17
RUN wget https://github.com/astral-sh/uv/releases/download/$UV_VERSION/uv-x86_64-unknown-linux-gnu.tar.gz && \
  tar -xzvf uv-x86_64-unknown-linux-gnu.tar.gz && \
  cp uv-x86_64-unknown-linux-gnu/* /usr/local/bin && \
  rm -rf uv-x86_64-unknown-linux-gnu*

# Install lua
RUN apt install -y luarocks

USER $USERNAME
WORKDIR /home/$USERNAME

# Install pyright via npm
RUN npm config set prefix /home/$USERNAME/.local
RUN npm install -g pyright
ENV PATH=$PATH:/home/$USERNAME/.local/bin

# Install cargo
RUN rustup toolchain install stable-gnu
ENV PATH=$PATH:/home/$USERNAME/.cargo/bin

# Install python via uv and install tools via uv/uvx
ENV PYTHON_VERSION=3.12
RUN uv python install $PYTHON_VERSION
RUN uv tool install ruff
RUN uv tool install pre-commit

# Install golang
ENV GOPATH=/home/$USERNAME/.go
RUN go install golang.org/x/tools/gopls@latest
ENV PATH=$PATH:/home/$USERNAME/.go/bin

# Install lua-language-server
ENV LUA_LANGUAGE_SERVER_VERSION=3.14.0
RUN wget https://github.com/LuaLS/lua-language-server/releases/download/$LUA_LANGUAGE_SERVER_VERSION/lua-language-server-$LUA_LANGUAGE_SERVER_VERSION-linux-x64.tar.gz && \
  mkdir /home/$USERNAME/.local/share/lua-language-server && \
  tar -C /home/$USERNAME/.local/share/lua-language-server -xzvf lua-language-server-$LUA_LANGUAGE_SERVER_VERSION-linux-x64.tar.gz && \
  ln -s /home/$USERNAME/.local/share/lua-language-server/bin/lua-language-server /home/$USERNAME/.local/bin/lua-language-server && \
  rm lua-language-server-$LUA_LANGUAGE_SERVER_VERSION-linux-x64.tar.gz

# Verify
RUN nvim --version && \
  cargo --version && \
  node --version && \
  npm --version && \
  uv --version && \
  uv run --python $PYTHON_VERSION python --version && \
  uvx ruff --version && \
  uvx pre-commit --version && \
  go help && \
  gopls help && \
  pyright --version && \
  lua-language-server --version

# Set-up/copy configs
RUN mkdir -p .config && chown $USERNAME:$USERNAME .config
RUN mkdir -p .config/nvim && chown $USERNAME:$USERNAME .config/nvim
RUN mkdir -p .config/tmux && chown $USERNAME:$USERNAME .config/tmux
RUN mkdir -p .config/git && chown $USERNAME:$USERNAME .config/git
COPY --chown=$USERNAME:$USERNAME .config /home/$USERNAME/.config

# Install plugins via Lazy (and will pre-install treesitter)
RUN nvim --headless "+Lazy! sync" +qa
