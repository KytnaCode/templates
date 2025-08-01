#!/usr/bin/env nix-shell
#! nix-shell -i zsh -p zsh gum go

mod="$(gum input --placeholder="github.com/diana-cavendish/my-awesome-module" --header="Enter module name")"
name="$(gum input --placeholder="my-awesome-package..." --header="Enter package name" --value="${mod##*/}")"
bin="$(gum input --placeholder="my-awesome-bin..." --header="Package binary (optional)" --value="$name")"
short="$(gum input --placeholder="an awesome package..." --header="One-line description (optional)")"
long=""

if [[ -n "$short" ]]; then
  long="$(gum write --header="Long description (optional)" --placeholder="an awesome package...")"
fi

if [[ -z "$mod" ]]; then
  echo "Module name cannot be empty!"

  exit 1
fi

if [[ -z "$name" ]]; then
  echo "Package name cannot be empty!"

  exit 1
fi

go mod init "$mod"
go get -u github.com/spf13/cobra
go mod tidy

sed -i "s=__MY_MODULE_NAME__=${mod:q}=g" main.go

gum confirm "Init git repository?" && git init && git add -N .
gum confirm "Use template's default golangci-lint config?" || rm -f .golangci.yml
gum confirm "Use direnv-nix?" && echo "use_flake" >.envrc && echo ".envrc created, allow it with $(direnv allow)"

sed -i "s/__MY_APP_NAME__/$name/g" flake.nix
sed -i "s/__MY_APP_NAME__/$name/g" README.md

if [[ -n "$bin" ]]; then
  sed -i "s/__MY_APP_BIN__/$bin/g" flake.nix
  sed -i "s/__MY_APP_BIN__/$bin/g" ./cmd/root.go
else
  sed -i 's/__MY_APP_BIN__/abc/g' ./cmd/root.go
fi

if [[ -n "$long" ]]; then
  sed -i "s/__MY_APP_LONG_DESCRIPTION__/$long/g" flake.nix
  sed -i "s/__MY_APP_LONG_DESCRIPTION__/$long/g" README.md
  sed -i "s/__MY_APP_LONG_DESCRIPTION__/$long/g" ./cmd/root.go
else
  sed -i "/__MY_APP_LONG_DESCRIPTION__/d" flake.nix
  sed -i "/__MY_APP_LONG_DESCRIPTION__/d" ./cmd/root.go
  # Don't delete placeholder from README.md, try to fallback to short description.
fi

if [[ -n "$short" ]]; then
  sed -i "s/__MY_APP_DESCRIPTION__/$short/g" flake.nix
  sed -i "s/__MY_APP_DESCRIPTION__/$short/g" ./cmd/root.go
  # If placeholder is still present, fallback t short description in README.md.
  sed -i "s/__MY_APP_LONG_DESCRIPTION__/$short/g" README.md
else
  sed -i '/__MY_APP_DESCRIPTION__/d' flake.nix
  sed -i '/__MY_APP_DESCRIPTION__/d' ./cmd/root.go
  sed -i '/__MY_APP_LONG_DESCRIPTION__/d' README.md
fi

rm -f init.sh
