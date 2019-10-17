#!/bin/bash

export MIX_ENV=prod
export PORT=4793

echo "Starting app..."

# Start to run in background from shell.

# Foreground for testing and for systemd
_build/prod/rel/teenpatti/bin/teenpatti start



