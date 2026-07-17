#!/bin/sh
if ! docker info >/dev/null 2>&1; then
  echo "Starting Docker daemon..."
  sudo dockerd --host=unix:///var/run/docker.sock --storage-driver=overlay2 >/tmp/dockerd.log 2>&1 &
  i=0
  while [ $i -lt 60 ]; do
    if docker info >/dev/null 2>&1; then break; fi
    sleep 0.5
    i=$((i+1))
  done
  if docker info >/dev/null 2>&1; then echo "Docker daemon started"; else echo "Docker daemon failed to start; see /tmp/dockerd.log" >&2; fi
fi
exec "$@"