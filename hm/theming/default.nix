{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    # ./stylix.nix
    ./gtk.nix
    ./qt.nix
  ];

  config = lib.mkIf config.azuride.enable {
    home.packages = with pkgs; [
      # Icon Themes
      adwaita-icon-theme
      colloid-icon-theme
      kora-icon-theme

      # Fonts
      adwaita-fonts
      departure-mono
      nerd-fonts.fira-code
    ];
  };
}
