{pkgs, lib, ...}: {
  gtk = {
    enable = true;
    theme = {
      package = lib.mkDefault pkgs.adw-gtk3;
      name = lib.mkDefault "adw-gtk3";
    };
  };
}
