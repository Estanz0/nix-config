{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    byron-home.starship.enable = lib.mkEnableOption "enable starship";
  };

  config = lib.mkIf config.byron-home.starship.enable {
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      settings = pkgs.lib.importTOML ./starship.toml;
    };
  };
}