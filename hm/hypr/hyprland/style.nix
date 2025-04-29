{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.azuride.enable {
    wayland.windowManager.hyprland.settings = {
      # exec = ["pgrep glpaper || glpaper DP-1 $XDG_CONFIG_HOME/wallpapers/shaders/Rainbow_Twister.frag.frag"];
      exec = ["swww-daemon & swww img ${../../components/wallpaper/images/imac_2021.jpg} -t none"];

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 1;
        "col.active_border" = "0x75757566";
        "col.inactive_border" = "0x75757566";
      };

      decoration = {
        rounding = 12;
        rounding_power = 4.0;

        blur = {
          enabled = true;
          size = 16;
          passes = 4;
          noise = 0.075;
          contrast = 1.2;
          brightness = 0.65;
          vibrancy = 0.8;
          vibrancy_darkness = 0.8;
          xray = true;
        };

        dim_inactive = true;
        dim_strength = 0.1;

        shadow = {
          enabled = true;
          range = 25;
          render_power = 2;
          color = "rgba(00000034)";
        };
      };

      animations = {
        enabled = true;

        bezier = ["halfEaseOut, 0.5, 0.5, 0, 1"];

        animation = [
          "windows, 1, 5, halfEaseOut, slide"
          "windowsOut, 1, 4, default, gnomed"
          "fade, 1, 5, default"
          "workspaces, 1, 5, default"
          "layers, 1, 3, halfEaseOut, slide"
        ];
      };

      layerrule = ["noanim, hyprpicker"];
    };
  };
}
