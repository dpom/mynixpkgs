{
  description = "package for cljstyle";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
      {
        # devShells.${system}.default = pkgs.mkShell {
        #   package = [
        #     pkgs.curl
        #   ];
        # };
        packages.${system}.default = (import ./package.nix { inherit pkgs; });
      };
}
