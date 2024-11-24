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
        # combobulate = pkgs.emacsWithPackages(epkgs: [
        #   (epkgs.callPackage ./pkgs/combobulate {
        #     # inherit (pkgs) fetchFromGitHub;
        #     # inherit (epkgs) melpaBuild;
        #   })]);
        etrans = pkgs.emacsWithPackages(epkgs: [
          (epkgs.callPackage ./pkgs/etrans {
            inherit (pkgs) fetchFromGitHub;
            inherit (epkgs) trivialBuild request;
          })]); 
      };
    };
    flake = {
      templates = import ./templates/templates.nix;
    };
  };
}
