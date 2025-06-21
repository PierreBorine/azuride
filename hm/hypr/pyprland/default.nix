{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) types;

  scratchpadSubmodule = types.submodule {
    options = {
      enable = lib.mkEnableOption "Whether to enable the scratchpad" // {default = true;};

      bind = lib.mkOption {
        type = types.str;
        description = "Hyprland's two first elements of a bind, used to open the scratchpad";
        example = "$mainMod, N";
      };

      options = lib.mkOption {
        type = types.attrsOf (types.either types.str types.bool);
        description = ''
          Additional scratchpad options.

          A `command` attribute is required.

          '[term]' and '[term_classed]' can be used to represent
          the default terminal, with and without the class flag.
          '[term_cmd]' is the flag used to provide a command to the terminal.

          It is required to add some kind of matcher. (eg: 'class')

          See documentation:
          https://hyprland-community.github.io/pyprland/scratchpads.html
        '';
        example = lib.literalExample {
          command = "[term_classed] neovim-scratch [term_cmd] nvim";
          class = "neovim-scratch";
          size = "96% 80%";
          margin = "8%";
          lazy = true;
        };
      };
    };
  };

  enabledScratchpads = lib.filterAttrs (_: v: v.enable) config.azuride.scratchpads;
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
        bind = "$mainMod, S";
        options = {
          command = "spotify";
          match_by = "initialTitle";
          initialTitle = "re:Spotify.*";
          size = "80% 75%";
        };
      };
    };
  };

  config = lib.mkIf config.azuride.enable {
    home.packages = [pkgs.pyprland];

    wayland.windowManager.hyprland.settings.bind =
      lib.mapAttrsToList (
        name: value:
          lib.throwIf (builtins.match "[^,]*,[^,]*$" value.bind == null) ''
            Scratchpads (${name}): 'bind' must be in the following format. "<modifier>, <key>" (got "${value.bind}")
          '' "${value.bind}, exec, pypr toggle ${name} #scratchpads: Toggle ${name} scratchpad"
      )
      enabledScratchpads;

    xdg.configFile."hypr/pyprland.toml".source = let
      scratchpads =
        builtins.mapAttrs (
          name: value:
            value.options
            |> lib.throwIf (
              # Don't throw if has "class" or ("match_by" with corresponding matcher)
              !(builtins.hasAttr "class" value.options
                || (builtins.hasAttr "match_by" value.options
                  && builtins.hasAttr value.options.match_by value.options))
            ) ''
              Scratchpads (${name}): a matcher option must be set. See official documentation here.
              https://hyprland-community.github.io/pyprland/scratchpads.html#class-recommended
            ''
            |> lib.throwIf (!(builtins.hasAttr "command" value.options && builtins.isString value.options.command)) ''
              Scratchpads (${name}): a string "command" option is mendatory.
            ''
        )
        enabledScratchpads;
      scratchpadsToml = pkgs.writers.writeTOML "scratchpads.toml" {inherit scratchpads;};
    in
      pkgs.writers.writeTOML "pyprland.toml" {
        pyprland = {
          plugins = ["scratchpads"];
          include = [
            scratchpadsToml
            "$XDG_CONFIG_HOME/hypr/pyprland-mutable.toml"
          ];

          variables = {
            term = "${lib.getExe config.azuride.terminal.package}";
            term_classed = "${lib.getExe config.azuride.terminal.package} ${config.azuride.terminal.class-flag}";
            term_cmd = config.azuride.terminal.command-flag;
          };
        };
      };

    # Additional mutable file for quick testing
    home.file.".config/hypr/pyprland-mutable.toml" = {
      text = "";
      force = true;
      azurideMutable = true;
    };
  };
}
