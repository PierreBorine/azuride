self: {
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./screenshots.nix
    ./colorpicker.nix
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
      inherit
        (config.azuride.config.locale)
        latitude
        longitude
        ;
    };

    services.udiskie = {
      enable = true;
      settings = {
        program_options.terminal = "footclient -D";
        icon_names = {
          media = ["media-eject-symbolic"];
        };
      };
    };
  };
}
