{
  config,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf config.azuride.enable {
    gtk = {
      enable = true;
      theme = {
        name = lib.mkDefault "Colloid";
        package = lib.mkDefault (pkgs.colloid-gtk-theme.override {
          colorVariants = ["dark"];
          tweaks = ["rimless" "normal"];
        });
      };
      iconTheme = {
        name = "kora";
        package = pkgs.kora-icon-theme;
      };
      cursorTheme = {
        name = lib.mkDefault "Bibata-Modern-Classic";
        package = lib.mkDefault pkgs.bibata-cursors;
        size = lib.mkDefault 24;
      };
    };
  };
}
