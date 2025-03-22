self: {
  imports = [
    ./impermanence.nix
    ./mutablility.nix
    (import ./components self)
    (import ./theming self)
    (import ./hypr self)
    ./module
  ];
}
