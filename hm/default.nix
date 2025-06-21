self: {
  imports = [
    ./impermanence.nix
    ./mutablility.nix
    (import ./components self)
    (import ./theming self)
    ./hypr
    ./programs
    ./module
  ];
}
