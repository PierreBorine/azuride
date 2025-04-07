self: {pkgs, ...}: {
  imports = [
    # ./stylix.nix
    ./gtk.nix
    (import ./qt.nix self)
  ];

  home.packages = with pkgs; [
    libsForQt5.qt5.qtsvg
    kdePackages.qtsvg

    # Icon Themes
    # TODO: actually test them
    adwaita-icon-theme
    # kdePackages.breeze-icons
    # colloid-icon-theme
    kora-icon-theme
    # fluent-icon-theme
    # vimix-icon-theme
    material-icons

    # Fonts
    adwaita-fonts
    departure-mono
    nerd-fonts.fira-code
  ];
}
