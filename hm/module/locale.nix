{lib, ...}:
with lib; {
  options.azuride.config.locale = {
    # default: Paris
    latitude = mkOption {
      type = types.float;
      default = 48.86;
      description = "Your latitude, defaults to Paris, used for automatic gradual blue light filter at sunset.";
    };
    longitude = mkOption {
      type = types.float;
      default = 2.34;
      description = "Your longitude, defaults to Paris, used for automatic gradual blue light filter at sunset.";
    };
  };
}
