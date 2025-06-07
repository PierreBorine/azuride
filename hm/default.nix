self: {
  imports = [
    ./impermanence.nix
    ./mutablility.nix
    (import ./components self)
    ./theming
    (import ./hypr self)
    ./programs
    ./module
  ];
}
