{local, ...}: {
  programs.niri.settings = {
    # Stylix's niri target sets border/focus-ring colors and the cursor, so we
    # only describe behaviour here.

    prefer-no-csd = true;

    input = {
      keyboard.xkb.layout = "us";
      touchpad = {
        tap = true;
        natural-scroll = true;
        dwt = true; # disable-while-typing
      };
      mouse.accel-profile = "flat";
      focus-follows-mouse.enable = true;
    };

    # ⇩ EDIT ME: name your outputs (`niri msg outputs` lists them) for scale/pos.
    outputs."eDP-1" = {
      scale = local.monitorScale;
    };

    layout = {
      gaps = 12;
      center-focused-column = "never";
      preset-column-widths = [
        {proportion = 1.0 / 3.0;}
        {proportion = 1.0 / 2.0;}
        {proportion = 2.0 / 3.0;}
      ];
      default-column-width.proportion = 1.0 / 2.0;
      focus-ring.width = 3;
      border.enable = false;
    };

    # noctalia is started as a systemd user service bound to the niri session
    # (see modules/home/noctalia.nix), so no spawn-at-startup needed.

    # Subtle, fast animations — omarchy-style polish without distraction.
    animations.slowdown = 0.7;

    # niri-flake's canonical attribute form: `action.<name> = <args>`. No-arg
    # actions take `{ }`; spawn takes a string or a list of argv strings.
    binds = {
      # Launchers
      "Mod+Return".action.spawn = "ghostty";
      # Noctalia v5 IPC: `noctalia msg <command>` (the old `ipc call` form and
      # the `noctalia-shell` binary are gone). The launcher is a named panel.
      "Mod+Space".action.spawn = [
        "noctalia"
        "msg"
        "panel-toggle"
        "launcher"
      ];
      "Mod+B".action.spawn = "zen-beta"; # browser
      "Mod+E".action.spawn = "nautilus"; # file manager

      # Window management
      "Mod+Q".action.close-window = {};
      "Mod+F".action.maximize-column = {};
      "Mod+Shift+F".action.fullscreen-window = {};
      "Mod+W".action.toggle-column-tabbed-display = {};
      "Mod+V".action.toggle-window-floating = {};

      # Focus
      "Mod+H".action.focus-column-left = {};
      "Mod+L".action.focus-column-right = {};
      "Mod+J".action.focus-window-down = {};
      "Mod+K".action.focus-window-up = {};

      # Move
      "Mod+Shift+H".action.move-column-left = {};
      "Mod+Shift+L".action.move-column-right = {};
      "Mod+Shift+J".action.move-window-down = {};
      "Mod+Shift+K".action.move-window-up = {};

      # Sizing
      "Mod+R".action.switch-preset-column-width = {};
      "Mod+Minus".action.set-column-width = "-10%";
      "Mod+Equal".action.set-column-width = "+10%";

      # Workspaces
      "Mod+1".action.focus-workspace = 1;
      "Mod+2".action.focus-workspace = 2;
      "Mod+3".action.focus-workspace = 3;
      "Mod+4".action.focus-workspace = 4;
      "Mod+5".action.focus-workspace = 5;
      "Mod+Shift+1".action.move-column-to-workspace = 1;
      "Mod+Shift+2".action.move-column-to-workspace = 2;
      "Mod+Shift+3".action.move-column-to-workspace = 3;
      "Mod+Shift+4".action.move-column-to-workspace = 4;
      "Mod+Shift+5".action.move-column-to-workspace = 5;

      # Screenshots
      "Print".action.screenshot = {};
      "Mod+Print".action.screenshot-window = {};
      "Ctrl+Print".action.screenshot-screen = {};

      # Help + session
      "Mod+Shift+Slash".action.show-hotkey-overlay = {};
      "Mod+Shift+E".action.quit = {};

      # Media / brightness keys
      "XF86AudioRaiseVolume".action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"];
      "XF86AudioLowerVolume".action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"];
      "XF86AudioMute".action.spawn = ["wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"];
      "XF86AudioPlay".action.spawn = ["playerctl" "play-pause"];
      "XF86AudioNext".action.spawn = ["playerctl" "next"];
      "XF86AudioPrev".action.spawn = ["playerctl" "previous"];
      "XF86MonBrightnessUp".action.spawn = ["brightnessctl" "set" "5%+"];
      "XF86MonBrightnessDown".action.spawn = ["brightnessctl" "set" "5%-"];
    };
  };
}
