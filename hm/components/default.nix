self: {
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./screenshots.nix
    (import ./colorpicker.nix self)
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
      kdePackages.qtwayland
      libsForQt5.qt5.qtwayland
      kdePackages.xwaylandvideobridge
    ];

    wayland.windowManager.hyprland.settings.exec-once = [
      "${lib.getExe pkgs.wl-clip-persist} --clipboard both"
    ];

    # Enable "$XDG_..." env vars
    xdg.enable = true;

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
        program_options.terminal = "${config.azuride.terminal.alt-cmd} ${config.azuride.terminal.work-dir-flag}";
        icon_names = {
          media = ["media-eject-symbolic"];
        };
      };
    };
  };
}
