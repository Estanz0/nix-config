{ config, pkgs, ... }:

{
  imports = [
    ./../../darwinModules
  ];

  environment.systemPackages = with pkgs; [ ];

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
        mineffect = "scale";
        minimize-to-application = true;
        orientation = "left";
        magnification = true;
        tilesize = 48;
        largesize = 64;
        wvous-tl-corner = 1; # Disabled
        wvous-tr-corner = 1; # Disabled
        wvous-bl-corner = 1; # Disabled
        wvous-br-corner = 1; # Disabled
      };

      # Login Window settings
      loginwindow = {
        autoLoginUser = "byron";
      };

      # Finder settings
      finder = {
        AppleShowAllFiles = true;
        FXDefaultSearchScope = "SCcf";
        FXPreferredViewStyle = "clmv";
        NewWindowTarget = "Home";
        ShowExternalHardDrivesOnDesktop = false;
        ShowPathbar = true;
        ShowStatusBar = true;
      };

      # Other Setings
      NSGlobalDomain = {
        NSAutomaticWindowAnimationsEnabled = false;
      };

      menuExtraClock = {
        Show24Hour = true;
      };
    };

    # Keyboard settings
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
  };
}