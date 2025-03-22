{lib, ...}: {
  imports = [
    ./inputs.nix
    ./locale.nix
  ];
  options.azuride = {
    enable = lib.mkEnableOption "My Hyprland based desktop environment";
  };
}
