{
  config,
  pkgs,
  lib,
  ...
}: {
  options.azuride.terminal = {
    kitty.enable = lib.mkEnableOption "Whether to configure the Kitty terminal" // {default = true;};

    package = lib.mkPackageOption pkgs "kitty" {};

    command-flag = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "The cli flag that is used to provde a command to the terminal";
    };
    class-flag = lib.mkOption {
      type = lib.types.str;
      default = "--app-id";
      description = "The cli flag that is used to change the terminal's window class";
    };
    work-dir-flag = lib.mkOption {
      type = lib.types.str;
      default = "--working-directory";
      description = "The cli flag that is used to change the terminal's default working directory";
    };
  };

  config = {
    home.packages = [config.azuride.terminal.package];

    programs.kitty = lib.mkIf config.azuride.terminal.kitty.enable {
      enable = true;
      settings = {
        # Cursor customisation
        cursor_shape = "block";
        cursor_blink_interval = 0;

        # Performance tuning
        sync_to_monitor = "yes";

        # Terminal bell
        enable_audio_bell = "no";

        # Window layout
        remember_window_size = "no";
        initial_window_width = 1066;
        initial_window_height = 668;
        window_padding_width = 6;
        confirm_os_window_close = 0;

        # Advanced
        shell_integration = "no-cursor";
      };
    };
  };
}
