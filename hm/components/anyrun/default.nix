self: {
  osConfig,
  config,
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [self.inputs.anyrun.homeManagerModules.default];

  config = lib.mkIf config.azuride.enable {
    wayland.windowManager.hyprland.settings = {
      bind = ["$mainMod, D, exec, anyrun"];
      layerrule = [
        "blur, anyrun"
        "ignorezero, anyrun"
        "animation slide top, anyrun"
      ];
    };

    programs.anyrun = {
      enable = true;
      config = {
        y = {fraction = 0.2;};
        width = {fraction = 0.28;};
        closeOnClick = true;
        showResultsImmediately = true;
        maxEntries = 10;

        plugins = with self.inputs.anyrun.packages.${pkgs.system}; [
          self.inputs.anyrun-nixos-options.packages.${pkgs.system}.default
          self.inputs.anyrun-better-websearch.packages.${pkgs.system}.default
          applications
          rink
          shell
        ];
      };

      extraCss = builtins.readFile (self.lib.compileScssFile "style.css" ./style.scss);

      extraConfigFiles = {
        "nixos-options.ron".text = let
          nixos-options = osConfig.system.build.manual.optionsJSON + "/share/doc/nixos/options.json";
          hm-options = inputs.home-manager.packages.${pkgs.system}.docs-json + "/share/doc/home-manager/options.json";
          options = builtins.toJSON {
            ":nix" = [nixos-options];
            ":hm" = [hm-options];
          };
        in ''
          Config(
              options: ${options},
              max_entries: Some(5)
           )
        '';

        "better-websearch.ron".text =
          # ron
          ''
            Config(
              prefix: "@",
              default_engine: Brave,
              engines: [
                Github,
                Custom(
                  name: "Nixpkgs",
                  url: "search.nixos.org/packages?query={}",
                  secondary_prefix: "nixpkgs",
                ),
                Custom(
                  name: "NixOS Options",
                  url: "search.nixos.org/options?query={}",
                  secondary_prefix: "nixopts",
                ),
                Custom(
                  name: "Home Manager",
                  url: "home-manager-options.extranix.com/?query={}",
                  secondary_prefix: "home",
                ),
                Custom(
                  name: "Noogle",
                  url: "noogle.dev/q?term={}",
                  secondary_prefix: "noogle",
                ),
                Custom(
                  name: "Github Nix",
                  url: "github.com/search?q=language%3ANix+{}&type=code",
                  secondary_prefix: "githubnix",
                ),
              ]
            )
          '';
      };
    };
  };
}
