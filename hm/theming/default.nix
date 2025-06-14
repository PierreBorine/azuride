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
    fonts.fontconfig.enable = true;
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

    home.pointerCursor = {
      name = lib.mkDefault "Bibata-Modern-Classic";
      package = lib.mkDefault pkgs.bibata-cursors;
      size = lib.mkDefault 24;
    };
  };
}
