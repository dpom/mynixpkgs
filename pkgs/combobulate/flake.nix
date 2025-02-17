{
  description = "combobulate";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; # This should point to whichever nixpkgs rev you want.
  };

  outputs = { flake-parts, ... } @ inputs: flake-parts.lib.mkFlake { inherit inputs; } {
    perSystem = { config, self', inputs', pkgs, system, ... }: {
      packages = rec {
        combobulate = pkgs.callPackage ./default.nix {
          inherit (pkgs) fetchFromGitHub;
          trivialBuild = pkgs.emacs.pkgs.trivialBuild;
        };
        default = combobulate;
      };
      devShells.default = pkgs.mkShell {
        packages = [
          self'.packages.default
        ];
      };
    };
    systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
  };
}
