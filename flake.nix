{
  description = "Kytnacode's template collections";

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
      go = pkgs.mkShell {
        buildInputs = with pkgs; [
          go
          golangci-lint
        ];
      };

      go-bun = pkgs.mkShell {
        buildInputs = with pkgs; [
          go
          golangci-lint

          bun
        ];
      };
    });

    templates = {
      go = {
        path = ./go;
        description = "module-based pure go project";
        welcomeText = ''
          # Go module

          ```
          chmod +x ./init.sh
          ./init.sh
          ```
        '';
      };

      go-cobra = {
        path = ./go-cobra;
        description = "go cli application based on cobra";
        welcomeText = ''
          # Go + Cobra

          ```
          chmod +x .init.sh
          ./init.sh
          ```
        '';
      };

      go-react = {
        path = ./go-react;
        description = "Go + React + Typescript application";
        welcomeText = ''
          # Go + React + Typescript

          Remember to run init script.

          ```
          chmod +x ./init.sh
          ./init.sh
          ```
        '';
      };
    };
  };
}
