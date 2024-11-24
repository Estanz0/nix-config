{ lib, config, ... }:
{
  options = {
    byron-home.xcode.enable = lib.mkEnableOption "enable xcode";
  };

  config = lib.mkIf config.byron-home.xcode.enable {
    programs.xcode = {
      enable = true;
    };
  };
}