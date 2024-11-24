{ lib, config, ... }:
{
  options = {
    byron-home.bat.enable = lib.mkEnableOption "enable bat";
  };

  config = lib.mkIf config.byron-home.bat.enable {
    programs.bat = {
      enable = true;
    };
  };
}