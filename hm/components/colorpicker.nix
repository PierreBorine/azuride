self: {
  config,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf config.azuride.enable {
    home.packages = [
      pkgs.hyprpicker
      (
        if config.azuride.config.alt-colorpicker
        then self.packages.x86_64-linux.termpicker
        else self.inputs.gcolor3.packages.${pkgs.system}.default
      )
    ];
    wayland.windowManager.hyprland.settings = {
      bind =
        ["CTRL, Print, exec, hyprpicker --autocopy #utilities: pick a color"]
        ++ (
          if config.azuride.config.alt-colorpicker
          then [
            (builtins.concatStringsSep " " [
              "CTRL&SHIFT, Print, exec,"
              "${lib.getExe config.azuride.terminal.package}"
              "${config.azuride.terminal.class-flag} termpicker"
              "termpicker --color \"$(hyprpicker --autocopy)\""
              "#utilities: pick a color and open termpicker"
            ])
          ]
          else [
            "CTRL&SHIFT, Print, exec, gcolor3 --color \"$(hyprpicker --autocopy)\" #utilities: pick a color and open gcolor3"
          ]
        );
      windowrule = [
        "float, class:(termpicker)"
        "size 525 373, class:(termpicker)"
        "minsize 525 373, class:(termpicker)"
        "float, class:(gcolor3)"
        "size 746 274, class:(gcolor3)"
      ];
    };
  };
}
