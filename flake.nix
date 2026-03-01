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

          ```
          chmod +x .init.sh
          ./init.sh
          ```
        '';
      };
    };
  };
}
