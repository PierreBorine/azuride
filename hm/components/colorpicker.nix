self: {
  config,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf config.azuride.enable {
    home.packages = [
      pkgs.hyprpicker
      self.inputs.gcolor3.packages.${pkgs.system}.default
    ];
    wayland.windowManager.hyprland.settings = {
      bind = [
        "CTRL, Print, exec, hyprpicker --autocopy #utilities: pick a color"
        "CTRL&SHIFT, Print, exec, gcolor3 --color \"$(hyprpicker --autocopy)\" #utilities: pick a color and open gcolor3"
      ];
      windowrule = [
        "float, class:(gcolor3)"
        "size 746 274, class:(gcolor3)"
      ];
    };
  };
}
