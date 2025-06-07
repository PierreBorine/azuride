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
    nix-packages = {
      url = "github:PierreBorine/nix-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags-config = {
      url = "github:PierreBorine/ags-config";
      # url = "/mnt/Modding Drive/Projects/Nix/ags-config";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pyprland.url = "github:hyprland-community/pyprland";
    # nixcord.url = "github:kaylorben/nixcord";
    # spicetify-nix = {
    #   url = "github:Gerg-L/spicetify-nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
  in {
    lib = import ./lib {inherit pkgs;};

    packages.${system} = {
      termpicker = pkgs.callPackage ./pkgs/termpicker.nix {};
    };

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
