{
  description = "Go + cobra template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    systems = ["x86_64-linux"];
    eachSystem = nixpkgs.lib.genAttrs systems (system: import nixpkgs {inherit system;});
  in {
    devShells = eachSystem (pkgs: {
      default = pkgs.mkShellNoCC {
        buildInputs = with pkgs; [
          git

          # Go packages
          cobra-cli
          go
          golangci-lint
        ];
      };

      CGO_ENABLED = 0;
    });

    packages = eachSystem (pkgs: rec {
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
