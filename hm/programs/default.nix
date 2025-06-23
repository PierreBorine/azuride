{lib, ...}: {
  options.azuride.config = {
    alt-colorpicker = lib.mkEnableOption "Whether to swap the colorpicker with a terminal based one";
  };

  imports = [
    ./terminal.nix
    ./non-core.nix
  ];
}
