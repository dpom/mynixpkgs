{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
  };

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in {
    packages.${system} = rec {
      hello = pkgs.hello;
      default = hello;
    };

    devShells.${system} = {
      hello = pkgs.mkShell {
        buildInputs = [ self.packages.${system}.hello ];
      };
    };
  };
}
