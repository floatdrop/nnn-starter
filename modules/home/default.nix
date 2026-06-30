{username, ...}: {
  imports = [
    ./cli.nix
    ./zsh.nix
    ./starship.nix
    ./git.nix
    ./ghostty.nix
    ./neovim.nix
    ./niri.nix
    ./noctalia.nix
    ./direnv.nix
    ./claude-code.nix
    ./apps.nix
    ./discord.nix
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";

  # Match system.stateVersion in hosts/nnn/default.nix. Don't bump casually.
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
}
