{lib, ...}: {
  options.azuride.config.inputs = {
    swap-case = lib.mkEnableOption "Swap the ESC and CAPSLOCK keys";
  };
}
