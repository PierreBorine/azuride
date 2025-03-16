{lib, ...}: let
  inherit (lib) mkOption types;
in {
  options.azuride = with types; {
    persist = {
      dirs = mkOption {
        type = listOf (either str attrs);
        default = [];
        description = ''
          A list of directories in your home directory that
          you would want to link to a persistent storage.
        '';
      };
      files = mkOption {
        type = listOf (either str attrs);
        default = [];
        description = ''
          A list of files in your home directory you would
          want to link to a persistent storage.
        '';
      };
    };
  };
}
