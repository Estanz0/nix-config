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

  outputs = { self, nixpkgs, darwin, home-manager, stylix, ... }@inputs:
  let
    system = "aarch64-darwin";

    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };

    specialArgs = {
      inherit inputs system personal;
    };

    extraSpecialArgs = {
      inherit inputs system personal;
    };

    personal = {
        user = "byron";
        timeZone = "Pacific/Auckland";
        defaultLocale = "en_NZ.UTF-8";
        city = "Auckland";

        # Used for gitconfig
        gitUser = "Estanz0";
        gitEmail = "68315031+Estanz0@users.noreply.github.com";
    };
  in
  {
    # nix-darwin configuration
    darwinConfigurations."Byrons-Mac-mini" = darwin.lib.darwinSystem {
      inherit pkgs specialArgs;

      modules = [
        ./hosts/mac-mini-m4/darwin-configuration.nix
      ];
    };

    # home-manager configuration
    homeConfigurations = {
      "${personal.user}@Byrons-Mac-mini" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs extraSpecialArgs;

      modules = [
        ./hosts/mac-mini-m4/home.nix
        stylix.homeManagerModules.stylix
      ];
      };
    };
  };
}
