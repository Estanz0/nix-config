{ lib, config, ... }:
{
  options = {
    byron-home.kitty.enable = lib.mkEnableOption "enable kitty";
  };



  config = lib.mkIf config.byron-home.kitty.enable {
    home = {
      file = {
          ".config/kitty/tab_bar.py".source = ./tab_bar.py;
      };
    };

    programs.kitty = {
      enable = true;

      font = {
        size = lib.mkForce 14;
        name = lib.mkForce "JetBrains Mono";
      };

      settings = {
        enable_audio_bell = false;

        # Tab bar settings
        tab_bar_style = "custom";
        tab_separator = " ";
        tab_title_template = " {index} {title} ";

        # MacOS specific settings
        macos_option_as_alt = true;
        macos_quit_when_last_window_closed = true;
      };

      keybindings = {
        "option+left" = "previous_tab";
        "option+right" = "next_tab";
        "command+1" = "goto_tab 1";
        "command+2" = "goto_tab 2";
        "command+3" = "goto_tab 3";
        "command+4" = "goto_tab 4";
        "command+5" = "goto_tab 5";
        "command+6" = "goto_tab 6";
        "command+7" = "goto_tab 7";
        "command+8" = "goto_tab 8";
        "command+9" = "goto_tab 9";
      };
    };
  };
}