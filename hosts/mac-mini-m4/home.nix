{ config, pkgs, ... }:

{

  imports = [
    ./../common/home.nix
  ];

  home = {
    username = "byron";
    homeDirectory = "/Users/byron";
    stateVersion = "23.11";

    packages = with pkgs; [ ];
  };

  byron-home = { };
}
