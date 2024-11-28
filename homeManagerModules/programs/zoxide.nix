{ lib, config, ... }:
{
  options = {
    byron-home.zoxide.enable = lib.mkEnableOption "enable zoxide";
  };

  config = lib.mkIf config.byron-home.zoxide.enable {
    programs.zoxide = {
      enable = true;
    };
  };
}