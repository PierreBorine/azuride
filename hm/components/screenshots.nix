{
  config,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf config.azuride.enable {
    home.packages = with pkgs; [
      hyprpicker
      hyprshot
      satty
    ];

    xdg.configFile."satty/config.toml".text = ''
      [general]
      fullscreen = true
      early-exit = true
      initial-tool = "crop"
      copy-command = "wl-copy"
      # Increase or decrease the size of the annotations
      annotation-size-factor = 1.2
      # After copying the screenshot, save it to a file as well
      save-after-copy = true
    '';

    wayland.windowManager.hyprland.settings = {
      layerrule = ["noanim, selection"];
      "$hyprshotBase" = builtins.concatStringsSep " " [
        "hyprshot"
        "--silent"
        "--output-folder"
        "'$XDG_PICTURES_DIR/Screenshots'"
        "--filename"
        "$(date '+%d-%m-%Y_%H:%M:%S.png')"
        "--mode"
      ];
      "$hyprshotSatty" = builtins.concatStringsSep " " [
        "--raw"
        "|"
        "satty"
        "--filename"
        "-"
        "--output-filename"
        "'$XDG_PICTURES_DIR/Screenshots/%d-%m-%Y_%H:%M:%S-edited.png'"
      ];
      bind = [
        "ALT, PRINT, exec, $hyprshotBase region --freeze"
        "$mainMod, PRINT, exec, $hyprshotBase window --freeze"
        ", PRINT, exec, $hyprshotBase output --mode active"
        "ALT&SHIFT, PRINT, exec, $hyprshotBase region --freeze $hyprshotSatty"
        "$mainMod&SHIFT, PRINT, exec, $hyprshotBase window --freeze $hyprshotSatty"
        "SHIFT, PRINT, exec, $hyprshotBase output --mode active $hyprshotSatty"
      ];
    };
  };
}
