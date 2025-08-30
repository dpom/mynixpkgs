{
  description = "main flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
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
          pkgs,
          ...
        }:
        {
          packages = {
            cljstyle = pkgs.callPackage ./pkgs/cljstyle { };
            dbeaver = pkgs.callPackage ./pkgs/dbeaver { };
            rmview = pkgs.callPackage ./pkgs/rmview { };
            aws2-wrap = pkgs.callPackage ./pkgs/aws2-wrap { };
            aws-vpn-client = pkgs.callPackage ./pkgs/aws-vpn-client {
              openvpn = pkgs.callPackage ./pkgs/aws-vpn-client/openvpn.nix {
                inherit (pkgs) openvpn;
              };
            };
            combobulate = pkgs.callPackage ./pkgs/combobulate {
              inherit (pkgs) fetchFromGitHub;
              trivialBuild = pkgs.emacs.pkgs.trivialBuild;
            };
            rcu = pkgs.callPackage ./pkgs/rcu { };
          };
        };
      flake = {
        templates = import ./templates/templates.nix;
      };
    };
}
