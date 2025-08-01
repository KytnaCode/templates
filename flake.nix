{
  description = "Kytnacode's template collections";

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
      go = pkgs.mkShell {
        buildInputs = with pkgs; [
          go
          golangci-lint
        ];
      };
    });

    templates = {
      go = {
        path = ./go;
        description = "module-based pure go project";
        welcomeText = ''
          # Go module
          ## Init project
          ```
          ./init.sh <module-name>
          rm -f ./init.sh
          ```

          To automatically enter devshell using `direnv` and `direnv-nix`
          ```
          direnv allow
          ```
        '';
      };

      go-cobra = {
        path = ./go-cobra;
        description = "go cli application based on cobra";
        welcomeText = ''
          # Go + Cobra

          ## Init project

          ./init.sh
        '';
      };
    };
  };
}
