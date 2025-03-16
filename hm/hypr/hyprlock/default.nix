{
  config,
  pkgs,
  lib,
  ...
}: let
  empty-window = lib.escapeShellArgs [
    (lib.getExe pkgs.foot) # Relies on patch to allow foot to be transparent in fullscreen
    "--title"
    "TRANSPARENT"
    "--app-id"
    "TRANSPARENT"
    "-o"
    "cursor.beam-thickness=0"
    "-o"
    "cursor.unfocused-style=none"
    "bash"
    "-c"
    "clear && while true; do clear; done"
  ];
  lock-script = pkgs.writeShellScriptBin "custom-session-lock" ''
    if ! pidof hyprlock > /dev/null; then
      ${empty-window} &
      hyprlock $1
      kill $!
    fi
  '';
in {
  imports = [./widgets.nix];
  config = lib.mkIf config.azuride.enable {
    lib.hyprlock = {
      inherit lock-script;
    };

    # Additional mutable file for quick testing
    home.file.".config/hypr/hyprlock-mutable.conf" = {
      text = "";
      force = true;
      mutable = true;
    };

    programs.hyprlock = {
      enable = true;
      sourceFirst = false; # Ensure source overrides Nix-defined options
      settings = {
        source = ["./hyprlock-mutable.conf"];
        background.monitor = "";
      };
    };

    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "${lib.getExe lock-script} --immediate";
        };
        listener = [
          {
            timeout = 600; # 10min
            on-timeout = "${lib.getExe lock-script}";
          }
        ];
      };
    };

    wayland.windowManager.hyprland.extraConfig = ''
      # Hyprlock
      exec-once = ${lib.getExe pkgs.wljoywake} # idle inhibit when using joysticks
      bind = $mainMod, L, exec, ${lib.getExe lock-script} --immediate
      windowrulev2 = fullscreen, class:(TRANSPARENT), initialTitle:(TRANSPARENT)
      windowrulev2 = noanim, class:(TRANSPARENT), initialTitle:(TRANSPARENT)
      windowrulev2 = float, class:(TRANSPARENT), initialTitle:(TRANSPARENT)
    '';
  };
}
