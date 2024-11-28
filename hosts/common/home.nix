{ pkgs, ... }:
{
  nix = {
    package = pkgs.nix;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  home = {
    stateVersion = "23.11";

    packages = with pkgs; [
      vscode

      wget
      curl
      jq

      cocogitto
      lazygit

      (python312.withPackages (p: with p; [
        requests
      ]))
     ];

  };

  imports = [
      ./../../homeManagerModules
  ];

  programs.home-manager.enable = true;

  byron-home = {
    # Programs
    kitty.enable = true;

    # Development programs
    git.enable = true;

    # Terminal programs
    zsh.enable = true;
    starship.enable = true;
    bat.enable = true;
    lsd.enable = true;

    # Misc
    stylix.enable = true;
  };
}