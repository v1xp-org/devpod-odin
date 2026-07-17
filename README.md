# ODIN + Raylib DevPod

A Docker-in-Docker enabled devcontainer with Odin compiler, Raylib support, and essential CLI tools.

## Features

- **Docker-in-Docker** — Run `docker` commands inside the container (privileged mode + dockerd)
- **Odin Compiler** — Latest Odin language compiler
- **Raylib Support** — X11 forwarding for GUI applications
- **Python UV** — Ultra-fast Python package manager
- **Neovim** — Built from source with full LSP support
- **Crush** — AI assistant (Charm)
- **LazyGit** — Terminal UI for git
- **Act** — Run GitHub Actions locally
- **Graphify** — Codebase knowledge graph
- **fzf** — Fuzzy finder for the shell and Neovim

## Quick Start

### With DevPod

```bash
devpod up ./odin
```

### With Docker Compose (local testing)

```bash
cd odin
docker compose up -d
docker compose exec devcontainer bash
```

### Build Image Manually

```bash
docker build -t odin-devpod -f .devcontainer/Dockerfile .devcontainer
```

## X11 Forwarding (Raylib)

The container supports X11 forwarding for GUI applications like Raylib.

### Host Setup

```bash
# Linux/macOS
xhost +local:docker

# Windows (WSLg)
# No action needed - automatic forwarding
```

### Testing

```bash
# Verify X11 forwarding works
xeyes  # Should display GUI window
```

### Raylib Usage

```bash
# Compile and run a Raylib project
odin run . -out:mygame
```

## Docker-in-Docker Usage

The container runs in privileged mode with its own Docker daemon:

```bash
# Start dockerd (auto-starts on shell open)
start-docker.sh

# Run containers
docker run --rm hello-world

# Build images
docker build -t myapp .

# Use Docker Compose
docker compose up
```

Docker storage persists via a named volume (`docker-storage`).

## Tools Included

| Tool | Version | Purpose |
|------|---------|---------|
| Odin | latest | Programming language |
| Docker CE | latest | Container runtime (DinD) |
| Python UV | latest | Package manager |
| Neovim | stable | Text editor |
| Crush | latest | AI assistant |
| LazyGit | latest | Git TUI |
| Act | latest | Local GitHub Actions |
| fzf | latest | Fuzzy finder |
| Graphify | latest | Code knowledge graph |
| Clang/LLD | latest | C/C++ toolchain (for Odin) |

## Architecture

```
odin/
├── .devcontainer/
│   ├── Dockerfile          # Multi-stage build
│   ├── devcontainer.json   # DevPod/VS Code config
│   └── .dockerignore       # Build exclusions
└── .github/
    └── workflows/
        └── build-image.yml # CI/CD pipeline
```

Note: `start-docker.sh` is auto-generated in the Dockerfile at `/usr/local/bin/start-docker.sh`.

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `DOCKER_IMAGE_NAME` | ODIN DevPod | Image name for builds |
| `DISPLAY` | ${localEnv:DISPLAY} | X11 display for GUI |
| `DOCKER_BUILDKIT` | 1 | Enable BuildKit |
| `COMPOSE_DOCKER_CLI_BUILD` | 1 | Use BuildKit for Compose |

## Customization

### Install Odin packages

```bash
odin get package-name
```

### Install Neovim plugins

Add to your `~/.config/nvim/init.lua` or use the built-in `:Lazy` plugin manager.

### Persistent storage

Docker data persists in the `docker-storage` volume. To reset:

```bash
docker volume rm docker-storage
```

## Troubleshooting

### Docker daemon not starting

```bash
# Check logs
cat /tmp/dockerd.log

# Restart manually
sudo dockerd --storage-driver=overlay2 &
```

### X11 forwarding not working

```bash
# Check DISPLAY variable
echo $DISPLAY

# Re-run xhost command on host
xhost +local:docker
```

### Permission denied

The `vscode` user is in the `docker` group. If issues persist:

```bash
sudo usermod -aG docker vscode
# Log out and back in
```

### Low disk space

Docker images accumulate in `/var/lib/docker`. Prune regularly:

```bash
docker system prune -a
```
