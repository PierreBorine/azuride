{
  config,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf config.azuride.enable {
    home.packages = with pkgs; [
      hyprpicker
      (gcolor3.overrideAttrs {
        version = "2.4.0";
        src = pkgs.fetchFromGitHub {
          owner = "PierreBorine";
          repo = "gcolor3";
          rev = "v2.4.0";
          sha256 = "uSELcjqWLoU119wg7Zquumd2D24BKlt5JWjuIlnNbQw=";
        };
        buildInputs = [
          pkgs.libhandy
          pkgs.libportal-gtk3
        ];
      })
    ];
    wayland.windowManager.hyprland.settings = {
      bind = [
        "ALT, Print, exec, gcolor3 --color \"$(hyprpicker --autocopy)\" #utilities: pick a color and open gcolor3"
        "ALT&SHIFT, Print, exec, hyprpicker --autocopy #utilities: pick a color"
      ];
      windowrulev2 = [
        "float, class:(gcolor3)"
        "size 746 313, class:(gcolor3)"
      ];
    };
  };
}
