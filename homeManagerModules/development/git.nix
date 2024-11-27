{
  lib,
  config,
  personal,
  ...
}:
{
  options = {
    byron-home.git.enable = lib.mkEnableOption "enable git";
  };

  config = lib.mkIf config.byron-home.git.enable {
    programs.git = {
      enable = true;
      userName = "${personal.gitUser}";
      userEmail = "${personal.gitEmail}";

      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = true;
      };
    };
  };
}