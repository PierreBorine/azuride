self: {
  config,
  lib,
  ...
}: {
  imports = [self.inputs.ags-config.homeManagerModules.default];

  config = lib.mkIf config.azuride.enable {
    ags-config = {
      enable = true;

      hyprland = {
        layerrules = true;
        autoStart = true;
        binds = false;
      };
    };

    azuride.persist.dirs = [".cache/astal"];
  };
}
