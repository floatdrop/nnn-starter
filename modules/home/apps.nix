{
  pkgs,
  inputs,
  ...
}: {
  # GUI desktop apps. Browsers and file managers live here rather than in the
  # CLI bundle. All get themed by Stylix (GTK + base16).
  home.packages = [
    # Zen browser — Firefox-based, from the community flake (beta channel).
    inputs.zen-browser.packages.${pkgs.system}.default

    # Nautilus (GNOME Files): a sensible GTK file manager. Pairs with the gvfs
    # service enabled in modules/nixos/desktop.nix for trash + mounting, and
    # backs the browser's "open/save" file picker via the gtk xdg portal.
    pkgs.nautilus
  ];

  # CLI tools that open URLs (`gh`, `git`, etc.) use $BROWSER. Beta channel's
  # binary is `zen-beta`.
  home.sessionVariables.BROWSER = "zen-beta";

  # Make Zen the default browser for http(s) + html.
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "zen-beta.desktop";
      "x-scheme-handler/http" = "zen-beta.desktop";
      "x-scheme-handler/https" = "zen-beta.desktop";
      "x-scheme-handler/about" = "zen-beta.desktop";
      "x-scheme-handler/unknown" = "zen-beta.desktop";
    };
  };
}
