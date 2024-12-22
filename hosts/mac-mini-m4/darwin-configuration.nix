
{ ... }:

{
  imports = [
    ./../common/darwin-configuration.nix
  ];

  homebrew = {
      enable = true;
      # onActivation.cleanup = "uninstall";

      taps = [];
      brews = [ "cowsay" ];
      casks = [];
  };
}