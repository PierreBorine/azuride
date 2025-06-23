{
  config,
  pkgs,
  lib,
  ...
}: let
  appList = with pkgs; [
    blueman # TODO: replace with "overskride" once feature-complete
    pwvucontrol
    iwgtk
    gnome-text-editor
    nautilus
  ];

  appOption = pkg: {
    enable = lib.mkEnableOption "Whether to install ${pkg.pname}, true by default" // {default = true;};
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = pkg;
    };
  };
in {
  options.azuride.non-core-apps =
    {enable = lib.mkEnableOption "Whether to install non-core apps, true by default" // {default = true;};}
    // (appList
      |> map (pkg: lib.nameValuePair pkg.pname (appOption pkg))
      |> lib.listToAttrs);

  config = lib.mkIf config.azuride.non-core-apps.enable {
    home.packages =
      config.azuride.non-core-apps
      |> lib.flip builtins.removeAttrs ["enable"]
      |> lib.attrValues
      |> builtins.filter (pkg: pkg.enable)
      |> map (pkg: pkg.package);
  };
}
