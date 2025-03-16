{pkgs, ...}: {
  home.packages = [pkgs.glpaper];
  xdg.configFile."wallpapers/shaders".source = ./shaders;
}
