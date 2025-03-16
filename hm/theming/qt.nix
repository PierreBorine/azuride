self: {pkgs, lib, ...}: {
  home.packages = with pkgs; [
    libsForQt5.qt5.qtsvg
    kdePackages.qtsvg
  ];

  wayland.windowManager.hyprland.settings.env = [
    "QT_QPA_PLATFORMTHEME,qt6ct" # Prefer 6 to 5
  ];

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.package = [
      self.inputs.darkly.packages.${pkgs.system}.darkly-qt5
      self.inputs.darkly.packages.${pkgs.system}.darkly-qt6
    ];
  };

  xdg.configFile = let
    mkConf = qtct: (lib.generators.toINI {} {
      Appearance = {
        color_scheme_path = "${qtct}/share/${qtct.pname}/colors/darker.conf";
        custom_palette = true;
        standard_dialogs = "xdgdesktopportal";
        icon_theme = "kora";
        style = "Darkly";
      };
      Interface = {
        buttonbox_layout = 3;
        gui_effects = "General, AnimateMenu, AnimateCombo, AnimateTooltip, AnimateToolBox";
      };
    });
  in {
    "qt6ct/qt6ct.conf".text = mkConf pkgs.kdePackages.qt6ct;
    "qt5ct/qt5ct.conf".text = mkConf pkgs.libsForQt5.qt5ct;
  };
}
