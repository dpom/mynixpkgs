{
  description = "Template for clojure projects";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
    mypkgs_repo.url = "git+https://github.com/dpom/mynixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, mypkgs_repo }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
          };
        };
        mypkgs = mypkgs_repo.packages.${system};
      in
        {
          devShells.default = pkgs.mkShell {
            packages = [
              pkgs.babashka
              pkgs.clj-kondo
              pkgs.clojure
              pkgs.dbeaver-bin
              pkgs.jdk22
              mypkgs.cljstyle
              pkgs.pandoc
            ];
          };
        });
}
