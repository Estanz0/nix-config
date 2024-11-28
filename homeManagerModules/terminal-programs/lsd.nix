{ lib, config, ... }:
{
  options = {
    byron-home.lsd.enable = lib.mkEnableOption "enable lsd";
  };

  config = lib.mkIf config.byron-home.lsd.enable {
    programs.lsd = {
      enable = true;
      enableAliases = true;

      settings = {
        layout = "oneline";
      };
    };
  };
}