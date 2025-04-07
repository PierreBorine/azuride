{
  config,
  pkgs,
  lib,
  ...
}: {
  options.azuride.terminal = {
    foot.enable = lib.mkEnableOption "Whether to configure the Foot terminal" // {default = true;};

    package = lib.mkPackageOption pkgs "foot" {};

    main-cmd = lib.mkOption {
      type = lib.types.str;
      default = "footclient";
      description = "The main binary to execute as the usual terminal you'll work in.";
    };
    alt-cmd = lib.mkOption {
      type = lib.types.str;
      default = "foot";
      description = ''
        The alternate binary to execute the terminal in some other scenarios.
        Mainly used for terminal applications in scratchpads and suchs things
        that requiers a separate process.
      '';
    };

    class-flag = lib.mkOption {
      type = lib.types.str;
      default = "--app-id";
      description = "The cli flag that is used to change the terminal's window class.";
    };
    work-dir-flag = lib.mkOption {
      type = lib.types.str;
      default = "--working-directory";
      description = "The cli flag that is used to change the terminal's default working directory";
    };
  };

  config = lib.mkIf config.azuride.terminal.foot.enable {
    programs.foot = {
      enable = true;
      server.enable = true;
      settings = {
        main = {
          pad = "6x6";
          # Fix color bug (temp)
          gamma-correct-blending = "no"; # TODO: remove when fixed
        };
        cursor.style = "beam";
        colors.alpha = 0.35;
      };
    };
  };
}
