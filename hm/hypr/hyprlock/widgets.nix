{
  config,
  pkgs,
  lib,
  ...
}: let
  # Thanks to github:FireDrop6000/hyprland-mydots
  song-status = pkgs.writeShellScriptBin "song-status-hyprlock" ''
    player_name=$(playerctl metadata --format '{{playerName}}')
    player_status=$(playerctl status)

    if [[ "$player_status" == "Playing" ]]; then
      if [[ "$player_name" == "spotify" || "$player_name" == "spotify_player" ]]; then
        song_info=$(playerctl metadata --format '{{title}}  󰓇   {{artist}}')
      elif [[ "$player_name" == "firefox" ]]; then
        song_info=$(playerctl metadata --format '{{title}}  󰈹   {{artist}}')
      elif [[ "$player_name" == "mpd" ]]; then
        song_info=$(playerctl metadata --format '{{title}}  󰎆   {{artist}}')
      elif [[ "$player_name" == "chromium" ]]; then
        song_info=$(playerctl metadata --format '{{title}}  󰊯   {{artist}}')
      fi
    fi

    echo "$song_info"
  '';
in {
  config = lib.mkIf config.azuride.enable {
    programs.hyprlock.settings = {
      animations.enable = true;
      bezier = [
        "easeOutQuart, 0.25, 1, 0.5, 1"
        "easeOutCubic, 0.33, 1, 0.68, 1"
      ];
      animation = [
        "fadeOut, 0, 0, default" # disable fadeout
        "inputField, 1, 1, easeOutQuart"
        "inputFieldColors, 1, 2, easeOutCubic"
      ];

      background.color = "rgba(0, 0, 0, 0)";

      input-field = [
        {
          monitor = "";
          size = "300, 30";
          position = "0, -470";
          outline_thickness = "0";
          dots_spacing = "0.55";
          dots_center = true;
          inner_color = "rgba(0, 0, 0, 0)";
          font_color = "rgb(238, 238, 238)";
          fade_on_empty = false;
          placeholder_text = "";
          check_color = "rgba(0, 0, 0, 0)";
          fail_color = "rgba(0, 0, 0, 0)";
          fail_text = "$FAIL <b>($ATTEMPTS)</b>";
        }
        { # State icon
          monitor = "";
          size = "20, 20";
          position = "0, -530";
          outline_thickness = "0";
          inner_color = "rgba(0, 0, 0, 0)";
          fade_on_empty = false;
          placeholder_text = "";
          check_color = "rgba(0, 0, 0, 0)";
          fail_color = "rgb(205, 63, 69)";
          capslock_color = "rgb(230, 205, 105)";
          bothlock_color = "rgb(230, 205, 105)"; # when both locks are active.
          hide_input = true;
        }
      ];

      label = [
        {
          # Music widget
          monitor = "";
          text = ''cmd[update:1000] echo "$(${song-status}/bin/song-status-hyprlock)"'';
          color = "rgb(238, 238, 238)";
          font_size = "18";
          font_family = "Adwaita Sans";
          position = "0, 100";
          halign = "center";
          valign = "center";
        }
        {
          # Date
          monitor = "";
          text = ''cmd[update:1000] echo "$(date +"%A, %B %d")"'';
          color = "rgb(238, 238, 238)";
          font_size = "20";
          font_family = "Adwaita Sans ExtraBold";
          position = "0, 400";
          halign = "center";
          valign = "center";
        }
        {
          # Time
          monitor = "";
          text = ''cmd[update:1000] echo "$(date +"%k:%M")"'';
          color = "rgb(238, 238, 238)";
          font_size = "93";
          font_family = "Adwaita Sans Black";
          position = "0, 253";
          halign = "center";
          valign = "center";
        }

        {
          monitor = "";
          text = "Locked";
          color = "rgb(238, 238, 238)";
          font_size = "12";
          font_family = "Adwaita Sans ExtraBold";
          position = "0, -407";
          halign = "center";
          valign = "center";
        }

        {
          monitor = "";
          text = "Enter Password";
          color = "rgb(238, 238, 238)";
          font_size = "10";
          font_family = "Adwaita Sans SemiBold";
          position = "0, -440";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
