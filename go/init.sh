#!/usr/bin/env nix
#! nix shell nixpkgs#go nixpkgs#bash nixpkgs#gum github:KytnaCode/scripts#license-sh --command bash
# shellcheck shell=bash

mod="$(gum input --placeholder="github.com/diana-cavendish/my-awesome-module" --header="Enter module name")"

go mod init "$mod"

gum confirm "Init git repository?" && git init && git add -N .
gum confirm "Use template's default golangci-lint config?" || rm -f .golangci.yml
gum confirm "Use direnv-nix?" &&
  echo "use_flake" >.envrc &&
  printf "\n\n.envrc\n.direnv" >>.gitignore &&
  echo ".envrc created, allow it with \`direnv allow\`"

pkgName="$(gum input --header="Insert package name" --placeholder="myawesomepackage...")"

pname="$(gum input --header="Insert binary name" --placeholder="myawesomebin..." --value="$pkgName")"

sed -i "s/__PACKAGE_NAME__/$pkgName/g" flake.nix
sed -i "s/__BIN_NAME__/$pname/g" flake.nix

license.sh

gum style \
  --foreground 212 --border-foreground 212 --border double \
  --align center --width 50 --margin "1 2" --padding "2 4" \
  "Project scaffolded sucefully, this script will self-destruct"

rm -f ./init.sh
