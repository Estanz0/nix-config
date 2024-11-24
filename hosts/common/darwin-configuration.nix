{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    iterm2
  ];
  system = {
    stateVersion = 4;
    defaults = {
      # Dock settings
      dock = {
        autohide = true;
        autohide-delay = 0.0;
        autohide-time-modifier = 0.0;
        expose-animation-duration = 0.12;
        launchanim = false;
        orientation = "left";
        tilesize = 36;
        wvous-tl-corner = 1; # Disabled
        wvous-tr-corner = 1; # Disabled
        wvous-bl-corner = 1; # Disabled
        wvous-br-corner = 1; # Disabled
      };
    };
  };
}