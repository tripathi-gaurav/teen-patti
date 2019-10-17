#!/bin/bash

export MIX_ENV=prod
export PORT=4793
export NODEBIN=`pwd`/assets/node_modules/.bin
export PATH="$PATH:$NODEBIN"

echo "Building..."

mkdir -p ~/.config
mkdir -p priv/static

mix deps.get
mix compile
(cd assets && npm install)
(cd assets && webpack --mode production)
mix phx.digest

echo "Generating release..."
mix release

#echo "Stopping old copy of app, if any..."
#_build/prod/rel/draw/bin/practice stop || true

echo "Starting app..."

_build/prod/rel/teenpatti/bin/teenpatti start

