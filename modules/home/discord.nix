{...}: {
  # Vesktop: a Wayland-native Discord client with Vencord baked in. Preferred
  # over the official `discord` package on Niri because screen-share with audio
  # works, and Vencord gives Stylix a CSS hook for theming.
  #
  # Theming is automatic: Stylix has a vesktop target (enabled by stylix.enable
  # in modules/nixos/stylix.nix) that writes a full base16 theme to
  # ~/.config/vesktop/themes/stylix.css and adds it to Vencord's enabledThemes,
  # so Discord tracks the same Kanagawa palette as everything else — no custom
  # CSS needed here.
  programs.vesktop = {
    enable = true;

    # Vesktop's own (Electron shell) settings.
    settings = {
      minimizeToTray = true;
      # Let the Wayland compositor draw the window frame.
      customTitleBar = false;
    };

    # Nix manages the package, so stop Vencord self-updating or nagging.
    vencord.settings = {
      autoUpdate = false;
      autoUpdateNotification = false;
      notifyAboutUpdates = false;
    };
  };
}
