{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.azuride.enable {
    # See: https://wiki.hyprland.org/Configuring/Environment-variables
    wayland.windowManager.hyprland.settings.env = [
      "XDG_CURRENT_DESKTOP,Hyprland"
      "XDG_SESSION_TYPE,wayland"
      "XDG_SESSION_DESKTOP,Hyprland"

      # Hint some apps to use Wayland instead of XWayland
      "NIXOS_OZONE_WL,1" # Electron
      "ELECTRON_OZONE_PLATFORM_HINT,auto" # Electron
      "MOZ_ENABLE_WAYLAND,1" # Firefox

      # QT
      "QT_AUTO_SCREEN_SCALE_FACTOR,1"
      "QT_QPA_PLATFORM,wayland;xcb"
      "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
    ] ++ (lib.optionals config.azuride.nvidia [
      "GBM_BACKEND,nvidia-drm"
      "__GLX_VENDOR_LIBRARY_NAME,nvidia"
      "LIBVA_DRIVER_NAME,nvidia"
      "NVD_BACKEND,direct" # Enable hardware video acceleration
    ]);
  };
}
