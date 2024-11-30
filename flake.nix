{
  description = "main flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = { flake-parts, ... } @inputs:  flake-parts.lib.mkFlake { inherit inputs; } {
    systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    perSystem = { config, self', inputs', pkgs, system, ... }: {
      packages = {
        cljstyle = pkgs.callPackage ./pkgs/cljstyle { };
        dbeaver = pkgs.callPackage ./pkgs/dbeaver { };
        rmview = pkgs.callPackage ./pkgs/rmview { };
        combobulate = pkgs.callPackage ./pkgs/combobulate {
          inherit (pkgs) fetchFromGitHub;
          trivialBuild = pkgs.emacs.pkgs.trivialBuild;
        };
        etrans = pkgs.callPackage ./pkgs/etrans {
          inherit (pkgs) fetchFromGitHub;
          trivialBuild = pkgs.emacs.pkgs.trivialBuild;
          request = pkgs.emacsPackages.request;
        };
        ent = pkgs.callPackage ./pkgs/ent {
          inherit (pkgs) fetchFromGitHub;
          trivialBuild = pkgs.emacs.pkgs.trivialBuild;
          seq = pkgs.emacsPackages.seq;
        };
      };
    };
    flake = {
      templates = import ./templates/templates.nix;
    };
  };
}
