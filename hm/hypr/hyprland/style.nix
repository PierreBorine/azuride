{config, lib, ...}: {
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
        rounding = 15;
        rounding_power = 4.0;

        blur = {
          enabled = true;
          size = 16;
          passes = 4;
          noise = 0.09;
          contrast = 0.8;
          brightness = 0.5;
          vibrancy = 0.8;
          vibrancy_darkness = 0.8;
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

        bezier = [
          "myBezier, 0.5, 0.5, 0, 1"
        ];

        animation = [
          "windows, 1, 5, myBezier, slide"
          "windowsOut, 1, 5, default, popin 80%"
          "border, 1, 6, default"
          "borderangle, 1, 8, default"
          "fade, 1, 5, default"
          "workspaces, 1, 5, default"
          "layers, 1, 3, myBezier, slide"
        ];
      };

      layerrule = [
        "noanim, hyprpicker"
      ];
    };
  };
}
