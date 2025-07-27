{
  description = "Kytnacode's template collections";

  outputs = {self}: {
    templates.go = {
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
  };
}
