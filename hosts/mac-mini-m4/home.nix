{ config, pkgs, personal, ... }:

{

  imports = [
    ./../common/home.nix
  ];

  home = {
    username = "${personal.user}";
    homeDirectory = "/Users/${personal.user}";

    packages = with pkgs; [ ];
  };

  byron-home = { };
}
