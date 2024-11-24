{ pkgs, ... }:
{
  nix = {
    package = pkgs.nix;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  imports = [
      ./../../homeManagerModules
  ];

  programs.home-manager.enable = true;

  byron-home = {
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