self: {
  config,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf config.azuride.enable {
    home.packages = with pkgs; [
      libsForQt5.qt5.qtsvg
      kdePackages.qtsvg

      self.inputs.nix-packages.packages.x86_64-linux.qt6ct-kde
      libsForQt5.qt5ct # WARN: Does not support kde color-schemes
    ];

    wayland.windowManager.hyprland.settings.env = [
      "QT_QPA_PLATFORMTHEME,qt6ct" # Prefer 6 to 5
    ];

    qt = {
      enable = true;
      platformTheme.name = "qt5ct"; # "qtct" = "qt5ct" + pkgs...qt5ct/qt6ct
      style.package = with pkgs; [darkly-qt5 darkly];

      kde.settings = {
        kdeglobals = {
          Icons.Theme = "Colloid-Dark";
          TerminalApplication = config.azuride.terminal.package.meta.mainProgram;
          UiSettings = {
            ColorScheme = "*";
          };
        };
      };
    };

    xdg.configFile = let
      mkConf = themePkg:
        lib.generators.toINI {} {
          Appearance = {
            color_scheme_path = "${themePkg}/share/color-schemes/Darkly.colors";
            custom_palette = true;
            standard_dialogs = "default";
            icon_theme = "Colloid-Dark";
            style = "Darkly";
          };
          Fonts = {
            fixed=''"Adwaita Mono,12,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"'';
            general=''"Adwaita Sans,12,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"'';
          };
          Interface = {
            buttonbox_layout = 3;
            gui_effects = "General, AnimateMenu, AnimateCombo, AnimateTooltip, AnimateToolBox";
          };
        };
    in {
      "qt6ct/qt6ct.conf".text = mkConf pkgs.darkly;
      "qt5ct/qt5ct.conf".text = mkConf pkgs.darkly-qt5;
    };

    azuride.persist.files = [
      ".config/kdeglobals"
    ];
  };
}
