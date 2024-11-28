{ config, pkgs, work, ... }:

{

  imports = [
    ./../common/home.nix
  ];

  home = {
    username = "${work.user}";
    homeDirectory = "/Users/${work.user}";

    packages = with pkgs; [ ];
  };

  byron-home = { };
}
