{
  config,
  pkgs,
  lib,
  ...
}: let
  lock-script = pkgs.writeShellScriptBin "custom-session-lock" ''
    if ! pidof hyprlock > /dev/null; then
      ags request 'show blur' -i ${config.ags-config.instanceName}
      hyprlock $1
      ags request 'hide blur' -i ${config.ags-config.instanceName}
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
      azurideMutable = true;
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
