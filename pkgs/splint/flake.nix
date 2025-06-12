{
  description = "splint";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    clj-nix.url = "github:jlesquembre/clj-nix";
  };

  outputs =
    { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      perSystem =
        {
          config,
          self',
          inputs',
          pkgs,
          system,
          ...
        }:
        let
          depsLock = pkgs.stdenv.mkDerivation {
            name = "custom-splint";
            src = pkgs.fetchFromGitHub {
              owner = "NoahTheDuke";
              repo = "splint";
              tag = "v1.20.0";
              hash = "sha256-8ry7evi23M2u9vAC4GYPmxpSZwrhYzWyyOeNSPkUgT0=";
            };
            installPhase = ''
              mkdir -p $out
              cp -r . $out
              cp ${./deps-lock.json} $out/deps-lock.json
            '';
          };
        in
        {
          packages = rec {
            splint = inputs.clj-nix.lib.mkCljApp {
              pkgs = pkgs;
              modules = [
                # Option list:
                # https://jlesquembre.github.io/clj-nix/options/
                {
                  name = "NoahTheDuke/splint";
                  main-ns = "noahtheduke.splint";
                  version = "1.20.0";
                  projectSrc = depsLock;

                  nativeImage.enable = true;

                  # customJdk.enable = true;
                }
              ];
            };
            default = splint;
          };
        };
    };
}
