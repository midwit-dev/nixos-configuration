{ lib, pkgs, config, ... }:

let
  color-theme = rec {
    bg = "#121212";
    bg-alt = "#212121";

    gray = "#535353";
    gray-alt = "#b3b3b3";

    fg = gray-alt;

    border = bg-alt;

    warning = "#edb926";
    critical = "#cf1133";
  };
in
{
  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    _JAVA_AWT_WM_NONREPARENTING = 1;
  };

  wayland.windowManager.sway = {
    enable = true;

    extraConfig = ''
      input * xkb_options compose:ralt
    '';

    config = rec {
      # Super/Win
      modifier = "Mod4";
      left = "h";
      right = "l";
      up = "k";
      down = "j";

      terminal = "foot";

      keybindings = lib.mkOptionDefault {
        "${modifier}+Return" = "exec ${terminal}";

        "${modifier}+d" = "exec \"rofi -modi drun,run -show drun\"";

        "${modifier}+f"       = "fullscreen toggle";
        "${modifier}+Shift+f" = "floating toggle";

        "${modifier}+t" = "layout toggle all";

        # Create quick emacs org-capture frame
        "${modifier}+c" = "exec --no-startup-id emacsclient --alternate-editor='' --create-frame --no-wait --eval '(mw/org-capture-from-desktop)'";

        "XF86AudioRaiseVolume" = "exec --no-startup-id amixer -M set Master 5%+";
        "XF86AudioLowerVolume" = "exec --no-startup-id amixer -M set Master 5%-";
        "XF86AudioMute"        = "exec --no-startup-id amixer -M set Master toggle";
        "XF86AudioNext"        = "exec --no-startup-id playerctl next";
        "XF86AudioPrev"        = "exec --no-startup-id playerctl previous";
        "XF86AudioPlay"        = "exec --no-startup-id playerctl play-pause";
      };

      bars = [
        {
          command = "${pkgs.waybar}/bin/waybar";
        }
      ];

      output = {
        "eDP-1" = {
          res = "1920x1080";
          pos = "3440 0";
        };

        "HDMI-A-1" = {
          mode = "3440x1440@100Hz";
          # res = "3440x1440";
          pos = "0 0";
        };

      };

      startup = [
      ];

      workspaceOutputAssign = [
        {
          workspace = "1";
          output = ["HDMI-A-1" "eDP-1"];
        }
        {
          workspace = "2";
          output = ["HDMI-A-1" "eDP-1"];
        }
        {
          workspace = "3";
          output = ["HDMI-A-1" "eDP-1"];
        }
        {
          workspace = "4";
          output = ["HDMI-A-1" "eDP-1"];
        }
        {
          workspace = "5";
          output = ["HDMI-A-1" "eDP-1"];
        }
        {
          workspace = "6";
          output = ["HDMI-A-1" "eDP-1"];
        }
        {
          workspace = "7";
          output = ["HDMI-A-1" "eDP-1"];
        }
        {
          workspace = "8";
          output = ["HDMI-A-1" "eDP-1"];
        }
        {
          workspace = "9";
          output = "eDP-1";
        }
        {
          workspace = "10";
          output = "eDP-1";
        }
      ];
    };
  };

  programs.waybar = {
    # enable if sway is enabled
    enable = config.wayland.windowManager.sway.enable;

    settings = {
      mainbar = {
        position = "bottom";
        height = 24;
        layer = "bottom";

        modules-left = [ "sway/workspaces" "sway/mode" ];
        modules-center = [ "custom/org-pomodoro" "sway/window" ];
        modules-right = [ "pulseaudio" "cpu" "memory" "temperature" "battery" "clock" "tray" ];

        "custom/org-pomodoro" = {
          exec = "~/.local/bin/scripts/pomodoro-bar.sh";
          exec-if = "${pkgs.procps}/bin/pgrep -x emacs";
        };

        pulseaudio = {
          format = "Vol {volume} {format_source}";
          format-bluetooth = "Volb {volume} {format_source}";
          format-bluetooth-muted = "Volb {format_source}";
          format-muted = "Vol mut {format_source}";
          format-source = "Mic {volume}";
          format-source-muted = "Mic mut";

          on-click = "pavucontrol";
        };

        cpu = {
          format = "{icon0} {icon1} {icon2} {icon3} {icon4} {icon5} {icon6} {icon7}";
          format-icons = ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█"];
          interval = 1;
        };

        memory = {
          format = "Mem {used:0.1f}/{total:0.1f}";
        };

        battery = {
          format = "Bat {capacity}%";
          states = {
            "warning" = 50;
            "critical" = 25;
          };
        };

        clock = {
          format = "{:%F %R W%V}";
        };
      };
    };

    style = ''
        * {
            border: none;
            border-radius: 0;
            font-size: 13px;
            font-family: Iosevka NF;
            color: ${color-theme.fg};
        }

        window#waybar {
            background: ${color-theme.bg};
            color: ${color-theme.fg};
        }

        box.module {
            padding: 0 5px;
        }

        label.module {
            border-right: 1px solid ${color-theme.border};
            padding: 0 10px;
        }

        label#window {
            border: none;
        }

        #workspaces button {
            background: transparent;
            padding: 0 3px;
            border-bottom: 3px solid transparent;
        }

        #workspaces button.focused {
            border-bottom: 3px solid ${color-theme.fg};
        }

        #battery {
            background: ${color-theme.bg};
            color: ${color-theme.fg};
        }

        #battery.warning {
            background: ${color-theme.warning};
            color: ${color-theme.bg};
        }

        #battery.critical {
            background: ${color-theme.critical};
            color: ${color-theme.fg};
        }
    '';
  };
}
