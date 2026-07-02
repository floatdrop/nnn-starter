{
  lib,
  pkgs,
  ...
}: {
  # `nix-shell` / `nix-shell -p` hardcode bash. any-nix-shell re-execs zsh
  # inside the ad-hoc environment so we keep our shell, aliases, and prompt.
  home.packages = [pkgs.any-nix-shell];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 50000;
      save = 50000;
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
    };

    # Modern-unix muscle memory: keep the old names, get the new tools.
    # The lsd module also defines ls/ll/la, so force ours to win the merge.
    shellAliases = {
      ls = lib.mkForce "lsd";
      ll = lib.mkForce "lsd -l";
      la = lib.mkForce "lsd -la";
      lt = lib.mkForce "lsd --tree";
      cat = "bat";
      top = "btop";
      du = "dust";
      df = "duf";
      ps = "procs";
      ping = "gping";
      vim = "nvim";
      vi = "nvim";
      g = "git";
      lg = "lazygit";

      # nh-powered rebuilds from anywhere.
      rebuild = "nh os switch";
      update = "nh os switch --update";
    };

    initContent = ''
      # Make Ctrl-arrow move by word.
      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;5D" backward-word

      # Keep zsh inside `nix-shell` instead of falling back to bash.
      ${pkgs.any-nix-shell}/bin/any-nix-shell zsh | source /dev/stdin
    '';
  };
}
