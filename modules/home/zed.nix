{
  lib,
  pkgs,
  ...
}: {
  # Zed — the GUI code editor. Neovim stays the terminal `$EDITOR`
  # (see modules/home/neovim.nix); Zed is what opens when you double-click a
  # text file in Nautilus or pick "open with default" from anywhere else.
  #
  # Stylix's zed target syncs our Maple Mono / Noto fonts into Zed. For the
  # colors we don't use Stylix's mechanically-generated "Base16 Kanagawa" — its
  # base16 mapping makes keywords a harsh red and its template emits an
  # appearance Zed rejects. Instead we use the hand-tuned "Kanagawa Wave" from
  # the kanagawa-themes extension (declared below so it installs reproducibly).
  programs.zed-editor = {
    enable = true;

    # Auto-installed on startup. Names come from the Zed extension registry:
    # https://github.com/zed-industries/extensions
    extensions = [
      "kanagawa-themes" # color theme, selected below
      "catppuccin-icons" # file-type icon theme, selected below
      "nix" # Nix language support
      "html" # HTML language support
    ];

    userSettings = {
      # Hand-tuned Kanagawa from the extension above. mkForce because the Stylix
      # zed target also sets `theme` (to its harsh Base16 build).
      theme = lib.mkForce "Kanagawa Wave";

      # File-type icons from the catppuccin-icons extension above.
      icon_theme = "Catppuccin Frappé";

      # Nix owns the package; don't let Zed try to update itself.
      auto_update = false;

      # No phone-home.
      telemetry = {
        diagnostics = false;
        metrics = false;
      };

      # Load the per-project devenv/direnv environment (modules/home/direnv.nix)
      # by running `direnv export` against the project root directly, rather than
      # only inheriting it from the shell Zed was launched from. Without this,
      # opening a folder cold misses the environment unless direnv had already
      # loaded in the launching shell.
      load_direnv = "direct";
    };
  };

  # Upstream's dev.zed.Zed.desktop runs `zeditor %U`, which opens files in the
  # *existing* Zed workspace. We want Nautilus double-clicks to land in a fresh
  # window, so define our own entry that adds Zed's `--new` flag and point the
  # MIME defaults below at it instead.
  xdg.desktopEntries."zed-new-window" = {
    name = "Zed (new window)";
    genericName = "Text Editor";
    exec = "zeditor --new %U";
    icon = "zed";
    type = "Application";
    startupNotify = true;
    categories = ["Utility" "TextEditor" "Development" "IDE"];
    mimeType = ["text/plain" "application/x-zerosize" "x-scheme-handler/zed"];
  };

  # Make Zed the default GUI handler for plain-text and source files. The
  # zen-browser module (modules/home/apps.nix) also claims text/plain, but only
  # with lib.mkDefault, so these plain assignments win. We deliberately leave
  # text/html and application/json to Zen.
  xdg.mimeApps = {
    enable = true;
    defaultApplications = let
      zed = "zed-new-window.desktop";
    in {
      "text/plain" = zed;
      "text/markdown" = zed;
      "text/x-readme" = zed;
      "text/x-python" = zed;
      "text/x-shellscript" = zed;
      "text/x-csrc" = zed;
      "text/x-chdr" = zed;
      "text/rust" = zed;
      "application/x-shellscript" = zed;
      "application/toml" = zed;
      "application/x-yaml" = zed;
      "application/xml" = zed;
    };
  };

  # The zed-editor package only ships a `zeditor` binary; add a `zed` symlink
  # so the obvious command works from a terminal (and from scripts/other tools,
  # which a shell alias wouldn't cover).
  home.packages = [
    (pkgs.runCommandLocal "zed-cmd" {} ''
      mkdir -p $out/bin
      ln -s ${pkgs.zed-editor}/bin/zeditor $out/bin/zed
    '')
  ];
}
