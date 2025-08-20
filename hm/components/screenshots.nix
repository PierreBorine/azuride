{
  config,
  pkgs,
  lib,
  ...
}: let
  date_format = "%d-%m-%Y_%H-%M-%S";
in {
  config = lib.mkIf config.azuride.enable {
    services.flameshot = {
      enable = true;
      settings = {
        General = {
          contrastOpacity = 153; # 60%
          uiColor = "#55B5DB";
          contrastUiColor = "#8FB64D";

          filenamePattern = date_format;
          savePath = "${config.xdg.userDirs.pictures}/Screenshots";

          useGrimAdapter = true; # Wayland

          showDesktopNotification = false;
          showHelp = true; # Might disable later
          showStartupLaunchMessage = false;
          disabledTrayIcon = true;
          # disable some buttons
          buttons = "@Variant(\\0\\0\\0\\x7f\\0\\0\\0\\vQList<int>\\0\\0\\0\\0\\x12\\0\\0\\0\\0\\0\\0\\0\\x1\\0\\0\\0\\x2\\0\\0\\0\\x3\\0\\0\\0\\x4\\0\\0\\0\\x5\\0\\0\\0\\x6\\0\\0\\0\\x12\\0\\0\\0\\xf\\0\\0\\0\\x16\\0\\0\\0\\x13\\0\\0\\0\\t\\0\\0\\0\\x10\\0\\0\\0\\n\\0\\0\\0\\v\\0\\0\\0\\x17\\0\\0\\0\\f\\0\\0\\0\\x11)";
        };
      };
    };

    home.packages = with pkgs; [
      hyprpicker
      hyprshot
      grim
    ];

    wayland.windowManager.hyprland.settings = {
      windowrule = [
        "move 0 0, title:(flameshot)"
        "pin, title:(flameshot)"
        "fullscreenstate, title:(flameshot)"
        "float, title:(flameshot)"
        "animation slide top, title:(flameshot)"
      ];
      "$hyprshot" = builtins.concatStringsSep " " [
        "hyprshot"
        "--silent"
        "--output-folder"
        "'$XDG_PICTURES_DIR/Screenshots'"
        "--filename"
        "$(date '+${date_format}.png')"
        "--mode"
      ];
      bind = [
        # default
        ", PRINT, exec, flameshot gui"

        # quick
        "ALT, PRINT, exec, $hyprshot region --freeze"
        "$mainMod, PRINT, exec, $hyprshot window --freeze"
      ];
    };
  };
}
