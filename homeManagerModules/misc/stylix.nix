{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    byron-home.stylix.enable = lib.mkEnableOption "enable stylix";
  };

  config = lib.mkIf config.byron-home.stylix.enable {
    stylix = {
      enable = true;
      polarity = "dark";

      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

      # Stylix needs an image for some reason
      image = pkgs.fetchurl {
        url = "https://www.pixelstalk.net/wp-content/uploads/2016/05/Epic-Anime-Awesome-Wallpapers.jpg";
        sha256 = "enQo3wqhgf0FEPHj2coOCvo7DuZv+x5rL/WIo4qPI50=";
      };

      fonts = {
        monospace = {
          package = pkgs.jetbrains-mono;
          name = "JetBrainsMono";
        };
      };

      cursor = {
        package = pkgs.catppuccin-cursors.mochaDark;
        name = "catppuccin-mocha-dark-cursors";
        size = 24;
      };

      opacity = {
        applications = 0.95;
        desktop = 0.95;
        terminal = 0.95;
        popups = 0.95;
      };

      targets = {
        waybar.enable = false;
      };
    };
  };
}