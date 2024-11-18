{
  description = "Template for python projects";
  inputs = {
    devenv-root = {
      url = "file+file:///dev/null";
      flake = false;
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
    devenv.url = "github:cachix/devenv";
    nixpkgs-python = {
      url = "github:cachix/nixpkgs-python";
      inputs = { nixpkgs.follows = "nixpkgs"; };
    };
  };

  outputs = inputs@{ flake-parts, nixpkgs, devenv-root, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.devenv.flakeModule
      ];
      systems = nixpkgs.lib.systems.flakeExposed;

      perSystem = { config, self', inputs', pkgs, system, ... }: {
        # Per-system attributes can be defined here. The self' and inputs'
        # module parameters provide easy access to attributes of the same
        # system.

        # Equivalent to  inputs'.nixpkgs.legacyPackages.hello;
        packages.default = pkgs.hello;

        devenv.shells.default = {
          # https://devenv.sh/reference/options/
          packages = [ config.packages.default ];
          # dotenv.enable = true;
          languages.python = {
            enable = true;
            version = "3.12";
            poetry = {
              enable = true;
              activate.enable = true;
              install.enable = true;
              install.quiet = false;
              install.compile = true;
            };
          };

          # enterShell = ''
          #   hello
          # '';
        };
      };
    };
}

 
