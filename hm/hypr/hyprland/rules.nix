{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.azuride.enable {
    wayland.windowManager.hyprland.settings = {
      windowrule = [
        "suppressevent maximise, class:.*"

        # Steam
        "float, initialClass:(steam),initialTitle:(Friends)"
        "size 340 680, initialClass:(steam),initialTitle:(Friends)"
        "float, initialClass:(steam),initialTitle:(Settings)"

        "float, class:(org.gnome.Calculator)"

        "float,center,stayfocused, class:(io.elementary.desktop.agent-polkit)"
        "float,center,stayfocused, class:(org.kde.polkit-kde-authentication-agent-1)"
      ];
    };
  };
}
