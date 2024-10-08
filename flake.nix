{
  description = "main flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
  };

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in
  {
    packages.${system} = rec {
      cljstyle = pkgs.callPackage ./pkgs/cljstyle { };
      dbeaver = pkgs.callPackage ./pkgs/dbeaver { };
      rmview = pkgs.callPackage ./pkgs/rmview { };
    };
    templates = import ./templates/templates.nix;
  };
}
