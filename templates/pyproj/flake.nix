{
  description = "Template for python projects";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs @ { flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs;}
      {
        debug = true;
        systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
        perSystem = { config, self', inputs', pkgs, system, ... }:
          let
            poetry2nix = inputs.poetry2nix.lib.mkPoetry2Nix { inherit pkgs; };
          in
            {
              packages = {
                pyproj = poetry2nix.mkPoetryApplication {
                  projectDir = ./.;

                  # set this to true to use premade wheels rather than the source
                  preferWheels = true;

                  # example of overrides: this enables interactive plotting support with GTK
                  overrides = poetry2nix.overrides.withDefaults (final: prev: {
                    matplotlib = with pkgs; prev.matplotlib.overridePythonAttrs 
                      {
                        passthru.args.enableGtk3 = true;
                      };
                  });
                  propagatedBuildInputs = with pkgs; [
                  ];
                };
                default = config.packages.pyproj;
              };

              # Shell for app dependencies.
              #
              # nix develop
              #
              # Use this shell for developing your app.
              devShells.default = pkgs.mkShell {
                inputsFrom = [config.packages.pyproj];
                package = with pkgs; [
                  poetry
                  # any development dependencies that you might have in nixpkgs
                ];
              };

              # Shell for poetry.
              #
              # nix develop .#poetry
              #
              # Use this shell for changes to pyproject.toml and poetry.lock.
              devShells.poetry = pkgs.mkShell {
                packages = [pkgs.poetry];
              };
            };
      };
}
