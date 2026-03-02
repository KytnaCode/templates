#!/usr/bin/env nix
#! nix shell nixpkgs#bash nixpkgs#jq nixpkgs#bun nixpkgs#gum nixpkgs#go github:KytnaCode/scripts#license-sh --command bash
# shellcheck shell=bash

mod="$(gum input --placeholder="github.com/diana-cavendish/my-awesome-module" --header="Enter module name")"

go mod init "$mod"

gum confirm "Init git repository?" && git init && git add -N .
gum confirm "Use template's default golangci-lint config?" || rm -f .golangci.yml
gum confirm "Use direnv-nix?" &&
  echo "use_flake" >.envrc &&
  printf "\n\n.envrc\n.direnv" >>.gitignore &&
  echo ".envrc created, allow it with \`direnv allow\`"
gum confirm "Use air for hot reloading?" || rm -f .air.toml

cd ./frontend || exit 1

if gum confirm "Use tailwindcss?"; then
  sed -i "s/id='app'//g" ./src/App.tsx
  sed -i 's/__TAILWIND_CLASSES__/className="w-full h-full p-0 m-0 grid place-items-center"/' ./src/App.tsx
  sed -i "/import '.\/App.css'/d" ./src/App.tsx
  rm -f ./src/App.css
else
  sed -i -e 's/tailwindcss()//g' -e "/import tailwindcss from '@tailwindcss\/vite'/d" vite.config.ts
  sed -i '/@import "tailwindcss"/d' ./src/index.css
  sed -i 's/__TAILWIND_CLASSES__//g' ./src/App.tsx
  package_json="$(cat package.json)"
  jq 'del(.dependencies | .tailwindcss, .["@tailwindcss/vite"])' <<<"$package_json" >package.json
fi

bunx prettier --write .

license.sh

gum format -- \
  "Project scaffolded succefully" \
  "Run:" \
  "\`cd ./frontend\`" \
  "\`bun install\`"

rm -f ../init.sh
