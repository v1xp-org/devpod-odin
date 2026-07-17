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

echo "Configuring SSH..."
mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh"

# Copy SSH keys from host (read-only mount)
if [ -d /tmp/host-ssh ] && [ "$(ls -A /tmp/host-ssh 2>/dev/null)" ]; then
  cp /tmp/host-ssh/id_* "$HOME/.ssh/" 2>/dev/null || true
  cp /tmp/host-ssh/*.pub "$HOME/.ssh/" 2>/dev/null || true
  chmod 600 "$HOME"/.ssh/id_* 2>/dev/null || true
  echo "SSH keys copied from host"
fi

# Create SSH config for GitHub
cat >"$HOME/.ssh/config" <<SSHEOF
Host github.com
  HostName github.com
  User git
  StrictHostKeyChecking accept-new
SSHEOF
chmod 600 "$HOME/.ssh/config"

# Use SSH agent if available
if [ -n "${SSH_AUTH_SOCK:-}" ] && [ -S "${SSH_AUTH_SOCK}" ]; then
  echo "SSH agent available at ${SSH_AUTH_SOCK}"
else
  echo "No SSH agent, using copied keys"
fi

echo "Configuring git..."
if [ -d /workspaces/odin/.git ]; then
  git config --local --add safe.directory /workspaces/odin
  git remote -v
else
  echo "Not a git repository, skipping git config"
fi
