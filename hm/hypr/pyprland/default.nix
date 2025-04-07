self: {
  config,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf config.azuride.enable {
    home.packages = [self.inputs.pyprland.packages.${pkgs.system}.pyprland];

    wayland.windowManager.hyprland.settings = {
      bind = [
        # Scratchpads
        "$mainMod, S, exec, pypr toggle spotify     #scratchpad: Toggle Spotify scratchpad"
        "$mainMod, T, exec, pypr toggle hmm         #scratchpad: Toggle todo scratchpad"
        "$mainMod, E, exec, pypr toggle vesktop     #scratchpad: Toggle Vesktop scratchpad"

        # Layout Center
        "$mainMod&CTRL, K, exec, pypr layout_center toggle  #layout_center: Toggle layout center"
        "$mainMod, K, exec, pypr layout_center next         #layout_center: Change to next window"
        "$mainMod&SHIFT, K, exec, pypr layout_center prev   #layout_center: Change to previous window"
      ];

      windowrulev2 = ["float, initialClass:(spotify)"];
    };

    xdg.configFile."hypr/pyprland.d" = {
      source = ./pyprland.d;
      recursive = true;
    };

    xdg.configFile."hypr/pyprland.toml".text = ''
      [pyprland]
      include = [
        "$XDG_CONFIG_HOME/hypr/pyprland.d",
        "$XDG_CONFIG_HOME/hypr/pyprland-mutable.toml"
      ]
      plugins = [ "layout_center" ]

      [pyprland.variables]
      term = "${config.azuride.terminal.alt-cmd}"
      term_classed = "${config.azuride.terminal.alt-cmd} ${config.azuride.terminal.class-flag}"
    '';

    # Additional mutable file for quick testing
    home.file.".config/hypr/pyprland-mutable.toml" = {
      text = "";
      force = true;
      azurideMutable = true;
    };
  };
}
