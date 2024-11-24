{
  description = "Nix Flake for independent nix-darwin and home-manager configurations";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixpkgs-unstable";
    };

    darwin = {
        url = "github:LnL7/nix-darwin/master";
        inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix";
  };



  outputs = { self, nixpkgs, darwin, home-manager, stylix, ... }:
  let
    system = "aarch64-darwin";

    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
  in
  {
    # nix-darwin configuration
    darwinConfigurations."Byrons-Mac-mini" = darwin.lib.darwinSystem {
      inherit pkgs;

      modules = [
        ./hosts/mac-mini-m4/darwin-configuration.nix
      ];
    };

    # home-manager configuration
    homeConfigurations = {
      "byron@Byrons-Mac-mini" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      modules = [
        ./hosts/mac-mini-m4/home.nix
        stylix.homeManagerModules.stylix
      ];
      };
    };
  };
}
