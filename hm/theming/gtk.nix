{
  config,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf config.azuride.enable {
    home.packages = [config.gtk.theme.package];
    gtk = {
      enable = true;
      theme = {
        name = lib.mkDefault "Colloid-Dark";
        package = lib.mkDefault (pkgs.colloid-gtk-theme.override {
          colorVariants = ["dark"];
          tweaks = ["rimless" "normal"];
        });
      };
      iconTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
      };
      cursorTheme = {
        name = lib.mkDefault "Bibata-Modern-Classic";
        package = lib.mkDefault pkgs.bibata-cursors;
        size = lib.mkDefault 24;
      };
    };
  };
}
