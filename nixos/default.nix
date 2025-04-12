self: {
  config,
  lib,
  ...
}: let
  cfg = config.azuride;
in {
  options.azuride = {
    enable = lib.mkEnableOption "My Hyprland based desktop environment";
  };

  config = lib.mkMerge [
    {home-manager.sharedModules = [self.homeManagerModules.default];}

    (lib.mkIf cfg.enable {
      programs.hyprland.enable = true;
      security.pam.services.hyprlock = {};

      programs.dconf.enable = true;

      home-manager.sharedModules = [
        {azuride.enable = lib.mkDefault true;}
      ];

      nix.settings = {
        experimental-features = ["nix-command" "flakes" "pipe-operators"];
        builders-use-substitutes = true;
        substituters = [
          "https://pierreborine.cachix.org"
          "https://ags.cachix.org"
          "https://anyrun.cachix.org"
        ];
        trusted-public-keys = [
          "pierreborine.cachix.org-1:D6WNCFqd5FZkTMem+QF+q25/lU2KFf8C7zBvvzhZZAk="
          "ags.cachix.org-1:naAvMrz0CuYqeyGNyLgE010iUiuf/qx6kYrUv3NwAJ8="
          "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
        ];
      };
    })
  ];
}
