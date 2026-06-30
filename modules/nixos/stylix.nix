{pkgs, ...}: {
  # One palette to rule them all. Stylix derives colors for niri, noctalia,
  # ghostty, bat, btop, neovim, GTK/Qt and more from a single base16 scheme.
  stylix = {
    enable = true;
    polarity = "dark";

    # Kanagawa, vendored in-repo so the build never depends on whatever version
    # of `base16-schemes` happens to be pinned. To use an upstream scheme
    # instead: stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/kanagawa.yaml";
    base16Scheme = ../../themes/kanagawa.yaml;

    # "Static mind, like the sea" (静心如海) — a meditating pepe before Hokusai's
    # Great Wave off Kanagawa, vendored in-repo (pngquant-optimized).
    image = ../../themes/wallpaper.png;

    # A hint of terminal transparency for that layered desktop look.
    opacity.terminal = 0.95;

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };

    fonts = {
      monospace = {
        package = pkgs.maple-mono.NF;
        name = "Maple Mono NF";
      };
      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };

      sizes = {
        terminal = 12;
        applications = 11;
        desktop = 11;
        popups = 11;
      };
    };
  };
}
