{
  description = "A Nix desktop environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # █▀ █▀█ █▀▀ ▀█▀ █░█░█ ▄▀█ █▀█ █▀▀
    # ▄█ █▄█ █▀░ ░█░ ▀▄▀▄▀ █▀█ █▀▄ ██▄
    anyrun.url = "github:anyrun-org/anyrun";
    anyrun-nixos-options.url = "github:n3oney/anyrun-nixos-options";
    anyrun-better-websearch.url = "github:PierreBorine/anyrun-better-websearch";
    gcolor3.url = "github:PierreBorine/gcolor3";
    ags-config = {
      url = "github:PierreBorine/ags-config";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pyprland.url = "github:hyprland-community/pyprland";
    # nixcord.url = "github:kaylorben/nixcord";
    # spicetify-nix = {
    #   url = "github:Gerg-L/spicetify-nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    darkly = {
      url = "github:Bali10050/Darkly";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  }: let
    pkgs = import nixpkgs {system = "x86_64-linux";};
  in {
    lib = import ./lib {inherit pkgs;};

    homeManagerModules = {
      default = self.homeManagerModules.azuride;
      azuride = import ./hm self;
    };

    nixosModules = {
      default = self.nixosModules.azuride;
      azuride = import ./nixos self;
    };
  };
}
