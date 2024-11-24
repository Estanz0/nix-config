{
  lib,
  config,
  ...
}:
{
  options = {
    byron-home.git.enable = lib.mkEnableOption "enable git";
  };

  config = lib.mkIf config.byron-home.git.enable {
    programs.git = {
      enable = true;
      userName = "Estanz0";
      userEmail = "byron.lg.smith@gmail.com";

      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = true;
      };
    };
  };
}