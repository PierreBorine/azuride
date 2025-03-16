{
  config,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf config.azuride.enable {
    home.packages = with pkgs; [
      grim
      satty
    ];

    xdg.configFile."satty/config.toml".text = ''
      [general]
      fullscreen = true
      early-exit = true
      initial-tool = "crop"
      copy-command = "wl-copy"
      # Increase or decrease the size of the annotations
      annotation-size-factor = 2
      # After copying the screenshot, save it to a file as well
      save-after-copy = false
    '';

    wayland.windowManager.hyprland.settings = {
      "$screenshot" = "grim -t ppm - | satty --output-filename ~/Pictures/Screenshots/%Y-%m-%d_%H:%M:%S.png -f -";

      windowrulev2 = ["float, initialClass:(com.gabm.satty)"];
      bind = [",Print, exec, $screenshot #utilities: Take a screenshot"];
    };
  };
}
