self: {lib, ...}: let
in {
  imports = [
    ./impermanence.nix
    ./mutablility.nix
    (import ./components self)
    (import ./theming self)
    (import ./hypr self)
  ];

  options.azuride = {
    enable = lib.mkEnableOption "My Hyprland based desktop environment";
  };
}
