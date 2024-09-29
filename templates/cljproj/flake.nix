{
  description = "Template for clojure projects";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    mypkgs_repo.url = "git+https://github.com/dpom/mynixpkgs";
  };

  outputs = { self, nixpkgs, mypkgs_repo }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      mypkgs = mypkgs_repo.packages.${system};
    in
      {
        packages.default = pkgs.callPackage  { };
        devShells.x86_64-linux.default = pkgs.mkShell {
          packages = [
            pkgs.babashka
            pkgs.clj-kondo
            pkgs.clojure
            pkgs.jdk22
            mypkgs.cljstyle
            pkgs.pandoc
          ];
        };
      };
}
