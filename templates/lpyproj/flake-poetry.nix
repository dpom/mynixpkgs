{
  description = "Template for basilisp projects";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mynixpkgs.url = "git+https://github.com/dpom/mynixpkgs";
  };
  outputs = inputs @ { flake-parts, mynixpkgs, ... }:
    flake-parts.lib.mkFlake { inherit inputs;}
      {
        debug = true;
        systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
        perSystem = { config, self', inputs', pkgs, system, ... }:
          let
            poetry2nix = inputs.poetry2nix.lib.mkPoetry2Nix { inherit pkgs; };
            mypkgs = mynixpkgs.packages.${system};
          in
            {
              packages = {
                default = poetry2nix.mkPoetryApplication {
                  projectDir = ./.;

                  # set this to true to use premade wheels rather than the source
                  preferWheels = true;

                  # example of overrides: this enables interactive plotting support with GTK
                  # overrides = poetry2nix.overrides.withDefaults (final: prev: {
                  #   matplotlib = with pkgs; prev.matplotlib.overridePythonAttrs 
                  #     {
                  #       passthru.args.enableGtk3 = true;
                  #     };
                  # });
                  # propagatedBuildInputs = with pkgs; [
                  # ];
                };
              };

              # Shell for app dependencies.
              #
              # nix develop
              #
              # Use this shell for developing your app.
              devShells.default = pkgs.mkShell {
                inputsFrom = [config.packages.default];
                # package = (with pkgs; [
                #   poetry
                #   babashka
                #   clj-kondo
                #   clojure
                #   jdk22
                # ]) ++ [mypkgs.cljstyle];
              };

              # Shell for poetry.
              #
              # nix develop .#poetry
              #
              # Use this shell for changes to pyproject.toml and poetry.lock.
              devShells.poetry = pkgs.mkShell {
                packages = [pkgs.poetry];
                shellHook = ''
                poetry completions bash >> ~/.bash_completion
                '';
              };
            };
      };
}
