{
  description = "Go + cobra template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs = {
    self,
    nixpkgs,
    systems,
  }: let
    eachSystem = nixpkgs.lib.genAttrs (import systems);
  in {
    devShells = eachSystem (system: let
      pkgs = import nixpkgs {inherit system;};
    in {
      default = pkgs.mkShell {
        buildInputs = with pkgs; [
          git

          # Go packages
          cobra-cli
          go
          golangci-lint
        ];
      };
    });

    packages = eachSystem (system: let
      pkgs = import nixpkgs {inherit system;};
    in rec {
      __MY_APP_NAME__ = pkgs.lib.buildGoModule {
        pname = "__MY_APP_NAME__";
        version = "0.1.0";

        src = ./.;

        meta = {
          description = "__MY_APP_DESCRIPTION__";
          longDescription = "__MY_APP_LONG_DESCRIPTION__";
          mainProgram = "__MY_APP_BIN__";
        };
      };

      default = __MY_APP_NAME__;
    });
  };
}
