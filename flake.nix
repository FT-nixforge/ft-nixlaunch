{
  description = "nixprism — a modern, polished Rofi application launcher for Wayland";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      packages = forAllSystems (system: rec {
        nixprism = nixpkgs.legacyPackages.${system}.callPackage ./package.nix { };
        default = nixprism;
      });

      homeManagerModules.default = import ./module.nix self;

      overlays.default = final: _prev: {
        nixprism = self.packages.${final.system}.default;
      };
    };
}
