{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.azuride.enable {
    wayland.windowManager.hyprland.settings = {
      windowrulev2 = [
        "suppressevent maximise, class:.*"

        # Steam
        "float, initialClass:(steam),initialTitle:(Friends)"
        "size 340 680, initialClass:(steam),initialTitle:(Friends)"
        "float, initialClass:(steam),initialTitle:(Settings)"

        "float, class:(org.gnome.Calculator)"

        "float,center,stayfocused,xray:1, class:(io.elementary.desktop.agent-polkit)"
        "float,center,stayfocused,xray:1, class:(org.kde.polkit-kde-authentication-agent-1)"
      ];
    };
  };
}
