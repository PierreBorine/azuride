{lib, ...}: {
  options.azuride.config.inputs = {
    layout = lib.mkOption {
      type = lib.types.str;
      default = "be";
      description = "Keyboard layout to use, see the Hyprland wiki https://wiki.hyprland.org/Configuring/Variables/#input";
    };

    swap-case = lib.mkEnableOption "Swap the ESC and CAPSLOCK keys";
  };
}
