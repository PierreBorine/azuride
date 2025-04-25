{config, pkgs, lib, ...}: {
  config = lib.mkIf config.azuride.enable {
    gtk = {
      enable = true;
      theme = {
        package = lib.mkDefault pkgs.adw-gtk3;
        name = lib.mkDefault "adw-gtk3";
      };
    };
  };
}
