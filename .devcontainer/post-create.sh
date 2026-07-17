#!/bin/sh
set -e

echo "Verifying installed tools..."
odin version
nvim --version
uv --version
crush --version
lazygit --version
act --version
fzf --version
npm --version
tmux -V
graphify --version || echo "graphify: not installed (optional)"
docker --version
docker compose version

echo "Configuring SSH agent..."
if [ -n "${SSH_AUTH_SOCK:-}" ] && [ -S "${SSH_AUTH_SOCK}" ]; then
  mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh"
  cat >"$HOME/.ssh/config" <<SSHEOF
Host github.com
  HostName github.com
  User git
  IdentityAgent ${SSH_AUTH_SOCK}
SSHEOF
  chmod 600 "$HOME/.ssh/config"
  echo "SSH agent forwarding configured (socket: ${SSH_AUTH_SOCK})"
else
  echo "No SSH agent socket found, skipping SSH config"
fi

echo "Configuring git..."
if [ -d /workspaces/odin/.git ]; then
  git config --local --add safe.directory /workspaces/odin
  git remote -v
else
  echo "Not a git repository, skipping git config"
fi