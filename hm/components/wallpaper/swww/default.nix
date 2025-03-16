{
  config,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf config.azuride.enable {
    home.packages = [pkgs.swww];
    wayland.windowManager.hyprland.settings.layerrule = [
      "noanim, swww-daemon"
    ];
  };
}
