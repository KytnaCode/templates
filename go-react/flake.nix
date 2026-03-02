{
  description = "A Go + React flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {nixpkgs, ...}: let
    systems = ["x86_64-linux"];
    eachSystem = f: nixpkgs.lib.genAttrs systems (system: f (import nixpkgs {inherit system;}));
  in {
    devShells = eachSystem (pkgs: {
      default = pkgs.mkShellNoCC {
        buildInputs = with pkgs; [
          # Backend
          go
          golangci-lint
          air

          # Frontend
          bun

          # Misc
          just
        ];

        CGO_ENABLED = 0;
      };
    });
  };
}
