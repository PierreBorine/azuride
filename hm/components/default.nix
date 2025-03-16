self: {
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./screenshots.nix
    ./colorpicker.nix
    ./udiskie.nix
    (import ./ags.nix self)
    ./wallpaper
    (import ./anyrun self)
  ];

  config = lib.mkIf config.azuride.enable {
    home.packages = with pkgs; [
      egl-wayland
      playerctl
      # TODO: add wifi/network manager
      blueman # TODO: replace with "overskride" once feature-complete
      pwvucontrol
      wl-clipboard
      wl-clip-persist
      kdePackages.qtwayland
      libsForQt5.qt5.qtwayland
      kdePackages.xwaylandvideobridge
    ];

    services.gammastep = {
      enable = true;
      # default: Paris
      latitude = 48.86;
      longitude = 2.34;
    };
  };
}
