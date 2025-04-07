{
  osConfig,
  lib,
  ...
}: {
  imports = [
    ./inputs.nix
    ./locale.nix
  ];
  options.azuride = {
    enable = lib.mkEnableOption "My Hyprland based desktop environment";
    # nvidia = lib.mkEnableOption "Whether you are using an NVIDIA gpu";
    nvidia = lib.mkOption {
      type = lib.types.bool;
      default = builtins.elem "nvidia" osConfig.services.xserver.videoDrivers;
      description = ''
        Whether you are using an NVIDIA gpu.
        Default tries to guess it automatically, but you should set this yourself anyway.
      '';
    };
  };
}
