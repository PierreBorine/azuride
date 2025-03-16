{config, lib, ...}: {
  config = lib.mkIf config.azuride.enable {
    services.udiskie = {
      enable = true;
      settings = {
        program_options.terminal = "footclient -D";
        icon_names = {
          media = ["media-eject-symbolic"];
        };
      };
    };
  };
}
