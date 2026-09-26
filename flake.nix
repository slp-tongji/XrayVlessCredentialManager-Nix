{
  description = "Nix packaging for XrayVlessCredentialManager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
    in
    {
      packages = forAllSystems (
        system:
        let
          package = nixpkgs.legacyPackages.${system}.callPackage ./package { };
        in
        {
          xray-vless-credential-manager = package;
          default = package;
        }
      );

      nixosModules =
        let
          module = ./nixos-module;
        in
        {
          xray-vless-credential-manager = module;
          default = module;
        };
    };
}
