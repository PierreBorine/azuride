{
  config,
  lib,
  ...
}: {
  # Disable some stylix modules so they don't interfere
  config = lib.mkIf (builtins.hasAttr "stylix" config) {
    stylix.targets.hyprland.enable = false;
    stylix.targets.hyprlock.enable = false;
    stylix.targets.kde.enable = false;
    stylix.targets.qt.enable = false;
  };
}
