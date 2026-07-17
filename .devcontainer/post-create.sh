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

echo "Configuring git..."
if [ -d /workspaces/odin/.git ]; then
  git config --local --add safe.directory /workspaces/odin
  git remote -v
else
  echo "Not a git repository, skipping git config"
fi