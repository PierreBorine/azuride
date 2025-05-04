{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.azuride.enable {
    wayland.windowManager.hyprland.settings = {
      "$mainMod" = "SUPER";

      input = {
        kb_layout = config.azuride.config.inputs.layout;
        kb_options =
          builtins.concatStringsSep ", " (["fkeys:basic_13-24"]
          ++ lib.optional config.azuride.config.inputs.swap-case "caps:swapescape");
        follow_mouse = 1;

        numlock_by_default = true;
        force_no_accel = false;

        repeat_rate = 35;
        repeat_delay = 300;

        sensitivity = 0.5;
      };

      binds = {
        scroll_event_delay = 100;
      };

      bind = [
        ## ▄▀█ █▀█ █▀█ █▀ ##
        ## █▀█ █▀▀ █▀▀ ▄█ ##
        "$mainMod, return, exec, ${lib.getExe config.azuride.terminal.package} #apps: Summon a terminal window"

        ## █░█░█ █ █▄░█ █▀▄ █▀█ █░█░█ █▀ ##
        ## ▀▄▀▄▀ █ █░▀█ █▄▀ █▄█ ▀▄▀▄▀ ▄█ ##
        "$mainMod, Q, killactive,     #hyprland: Kill focused window"
        "$mainMod, X, togglesplit,    #hyprland: Toggle split direction"
        "$mainMod, V, togglefloating, #hyprland: Toggle floating"
        "$mainMod, W, fullscreen,     #hyprland: Toggle fullscreen"

        # Move focus with mainMod + arrow keys
        "$mainMod, left,  movefocus, l #hyprland: Move focus left"
        "$mainMod, right, movefocus, r #hyprland: Move focus right"
        "$mainMod, up,    movefocus, u #hyprland: Move focus up"
        "$mainMod, down,  movefocus, d #hyprland: Move focus down"

        # Move windows with mainMod + SHIFT + arrow keys
        "$mainMod&SHIFT, left,  movewindow, l #hyprland: Move window left"
        "$mainMod&SHIFT, right, movewindow, r #hyprland: Move window right"
        "$mainMod&SHIFT, up,    movewindow, u #hyprland: Move window up"
        "$mainMod&SHIFT, down,  movewindow, d #hyprland: Move window down"

        ## █░█░█ █▀█ █▀█ █▄▀ █▀ █▀█ ▄▀█ █▀▀ █▀▀ █▀ ##
        ## ▀▄▀▄▀ █▄█ █▀▄ █░█ ▄█ █▀▀ █▀█ █▄▄ ██▄ ▄█ ##
        "$mainMod, Tab, workspace, e+1"
        "$mainMod&SHIFT, Tab, workspace, e-1"

        # Switch workspaces with mainMod + [0-9]
        "$mainMod, code:10, workspace, 1  #hyprland: Switch to the 1st workspace"
        "$mainMod, code:11, workspace, 2  #hyprland: Switch to the 2nd workspace"
        "$mainMod, code:12, workspace, 3  #hyprland: Switch to the 3rd workspace"
        "$mainMod, code:13, workspace, 4  #hyprland: Switch to the 4th workspace"
        "$mainMod, code:14, workspace, 5  #hyprland: Switch to the 5th workspace"
        "$mainMod, code:15, workspace, 6  #hyprland: Switch to the 6th workspace"
        "$mainMod, code:16, workspace, 7  #hyprland: Switch to the 7th workspace"
        "$mainMod, code:17, workspace, 8  #hyprland: Switch to the 8th workspace"
        "$mainMod, code:18, workspace, 9  #hyprland: Switch to the 9th workspace"
        "$mainMod, code:19, workspace, 10 #hyprland: Switch to the 10th workspace"

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "$mainMod&SHIFT, code:10, movetoworkspace, 1 #hyprland: Move window to 1st workspace"
        "$mainMod&SHIFT, code:11, movetoworkspace, 2 #hyprland: Move window to 2nd workspace"
        "$mainMod&SHIFT, code:12, movetoworkspace, 3 #hyprland: Move window to 3rd workspace"
        "$mainMod&SHIFT, code:13, movetoworkspace, 4 #hyprland: Move window to 4th workspace"
        "$mainMod&SHIFT, code:14, movetoworkspace, 5 #hyprland: Move window to 5th workspace"
        "$mainMod&SHIFT, code:15, movetoworkspace, 6 #hyprland: Move window to 6th workspace"
        "$mainMod&SHIFT, code:16, movetoworkspace, 7 #hyprland: Move window to 7th workspace"
        "$mainMod&SHIFT, code:17, movetoworkspace, 8 #hyprland: Move window to 8th workspace"
        "$mainMod&SHIFT, code:18, movetoworkspace, 9 #hyprland: Move window to 9th workspace"
        "$mainMod&SHIFT, code:19, movetoworkspace, 10 #hyprland: Move window to 10th workspace"
      ];

      # Do even when locked & repeat on hold
      bindle = [
        # Change audio level
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%-"
      ];

      # Do even when locked
      bindl = [
        ", XF86AudioStop, exec, playerctl stop"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioPlay, exec, playerctl play-pause" # key is called play, but it toggles
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      # Repeat on hold
      binde = [
        # Resize windows with mainMod + CTRL + arrow keys
        "$mainMod&CTRL, right,resizeactive,120 0"
        "$mainMod&CTRL, left,resizeactive,-120 0"
        "$mainMod&CTRL, up,resizeactive,0 -120"
        "$mainMod&CTRL, down,resizeactive,0 120"
      ];

      # Mouse binds
      bindm = [
        # Move/resize windows with mainMod + LMB/RMB and dragging
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
    };
  };
}
