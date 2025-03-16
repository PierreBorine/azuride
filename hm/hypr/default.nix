self: {
  imports = [
    ./hyprland
    ./hyprlock
    (import ./pyprland self)
  ];
}
