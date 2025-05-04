{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./style.nix
    ./binds.nix
    ./rules.nix
    ./env.nix
  ];

  config = lib.mkIf config.azuride.enable {
    # Additional mutable file for quick testing
    home.file.".config/hypr/hyprland-mutable.conf" = {
      text = "";
      force = true;
      azurideMutable = true;
    };

    wayland.windowManager.hyprland = {
      enable = true;
      sourceFirst = false; # Ensure source overrides Nix-defined options
      plugins = with pkgs.hyprlandPlugins; [
        hypr-dynamic-cursors
      ];
      settings = {
        source = ["hyprland-mutable.conf"];

        exec = [
          "pgrep .pypr-wrapped && pypr reload || pypr"
        ];

        exec-once = [
          # Find a way to play it 500ms earlier to be more in sync
          "${pkgs.sox}/bin/play --volume 0.2 ${./uiSounds/startup-smooth-activation.mp3}" # Startup sound
        ];

        monitor = [
          # Recommended rule for quickly plugging in random monitors
          ",preferred,auto,auto"
        ];

        general = {
          layout = "dwindle";
          resize_on_border = true;

          allow_tearing = false;
        };

        misc = {
          middle_click_paste = false;
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
        };

        cursor = {
          no_hardware_cursors = config.azuride.nvidia;
        };

        dwindle = {
          preserve_split = true;
        };

        plugin = {
          dynamic-cursors = {
            enabled = true;
            mode = "tilt";
            shake.enabled = false;
          };
        };
      };
    };

    # crash logs
    azuride.persist.dirs = [".cache/hyprland"];
  };
}
