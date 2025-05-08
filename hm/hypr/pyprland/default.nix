self: {
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) types;

  scratchpadSubmodule = types.submodule {
    options = {
      enable = lib.mkEnableOption "Whether to enable the scratchpad" // {default = true;};
      command = lib.mkOption {
        type = types.str;
        description = ''
          The shell command to execute with the scratchpad.

          '[term]' and '[term_classed]' can be used to represent
          the default terminal, with and without the class flag.

          '[term_cmd]' is the flag used to provide a command to the terminal.
        '';
        example = "[term_classed] neovim-scratch [term_cmd] nvim";
      };

      bind = lib.mkOption {
        type = types.str;
        description = "Hyprland's two first elements of a bind, used to open the scratchpad";
        example = "$mainMod, N";
      };

      options = lib.mkOption {
        type =
          types.attrsOf
          (types.either types.str types.bool);
        description = ''
          Additional scratchpad options.

          It is required to add some kind of matcher. (eg: 'class')

          See documentation:
          https://hyprland-community.github.io/pyprland/scratchpads.html
        '';
        example = lib.literalExample {
          class = "neovim-scratch";
          size = "96% 80%";
          margin = "8%";
          lazy = true;
        };
      };
    };
  };

  scratchpadsList =
    lib.attrsToList (lib.filterAttrs (_: v: v.enable) config.azuride.scratchpads);
in {
  options.azuride.scratchpads = lib.mkOption {
    type = types.attrsOf scratchpadSubmodule;
    default = {};
    description = ''
      Attribute set of Pyprland scratchpads.

      See documentation:
      https://hyprland-community.github.io/pyprland/scratchpads.html
    '';
    example = lib.literalExample {
      spotify = {
        command = "spotify";
        bind = "$mainMod, S";
        options = {
          match_by = "initialTitle";
          initialTitle = "re:Spotify.*";
          size = "80% 75%";
        };
      };
    };
  };

  config = lib.mkIf config.azuride.enable {
    home.packages = [self.inputs.pyprland.packages.${pkgs.system}.pyprland];

    wayland.windowManager.hyprland.settings.bind =
      builtins.map (
        {
          name,
          value,
        }:
          lib.throwIf (builtins.match "[^,]*,[^,]*$" value.bind == null) ''
            Scratchpads (${name}): 'bind' must be in the following format. "<modifier>, <key>" (got "${value.bind}")
          '' "${value.bind}, exec, pypr toggle ${name} #scratchpads: Toggle ${name} scratchpad"
      )
      scratchpadsList;

    xdg.configFile."hypr/pyprland.toml".text = let
      scratchpads =
        lib.concatMapStringsSep "\n" (
          {
            name,
            value,
          }: let
            optionNames = builtins.attrNames value.options;
            optionsList = lib.attrsToList value.options;
            optionsListChecked =
              lib.throwIf (
                if builtins.elem "class" optionNames
                then false # don't throw if using the 'class' option
                else if builtins.elem "match_by" optionNames
                # don't throw if using 'match_by' and one of these:
                then
                  if builtins.elem value.options.match_by optionNames
                  then false
                  else true
                else true
              ) ''
                Scratchpads (${name}): a matcher option must be set. See official documentation here.
                https://hyprland-community.github.io/pyprland/scratchpads.html#class-recommended
              ''
              optionsList;

            options =
              lib.concatMapStringsSep "\n" (
                a: "${a.name} = ${builtins.toJSON a.value}"
              )
              optionsListChecked;
          in ''
            [scratchpads.${name}]
            command = "${value.command}"
            ${options}
          ''
        )
        scratchpadsList;
      scratchpadsToml = pkgs.writeText "scratchpads.toml" scratchpads;
    in
      # toml
      ''
        [pyprland]
        plugins = [ "scratchpads" ]
        include = [
          "${scratchpadsToml}",
          "$XDG_CONFIG_HOME/hypr/pyprland-mutable.toml"
        ]

        [pyprland.variables]
        term = "${lib.getExe config.azuride.terminal.package}"
        term_classed = "${lib.getExe config.azuride.terminal.package} ${config.azuride.terminal.class-flag}"
        term_cmd = "${config.azuride.terminal.command-flag}"
      '';

    # Additional mutable file for quick testing
    home.file.".config/hypr/pyprland-mutable.toml" = {
      text = "";
      force = true;
      azurideMutable = true;
    };
  };
}
