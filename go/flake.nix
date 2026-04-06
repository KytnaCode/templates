{
  description = "A very basic Go flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    systems = ["x86_64-linux"];
    eachSystem = f: nixpkgs.lib.genAttrs systems (system: f (import nixpkgs {inherit system;}));
  in {
    devShells = eachSystem (pkgs: {
      default = pkgs.mkShellNoCC {
        buildInputs = with pkgs; [
          git

          # Go packages
          go
          golangci-lint
        ];

        CGO_ENABLE = 0;
      };
    });

    packages = eachSystem (pkgs: rec {
      default = __PACKAGE_NAME__;

      __PACKAGE_NAME__ = pkgs.buildGoModule (finalAttrs: {
        pname = "__BIN_NAME__";
        version = "0.1.0";

        src = ./.;

        vendorHash = "__PACKAGE_HASH__";

        env.CGO_ENABLED = 0;
      });
    });
  };
}
