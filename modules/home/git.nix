{local, ...}: {
  programs.git = {
    enable = true;

    # ⇩ Identity comes from local.nix.
    userName = local.gitUserName;
    userEmail = local.gitUserEmail;

    # delta gives syntax-highlighted, side-by-side diffs (themed by Stylix).
    delta = {
      enable = true;
      options = {
        navigate = true;
        line-numbers = true;
        side-by-side = true;
      };
    };

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      merge.conflictstyle = "zdiff3";
      diff.colorMoved = "default";
    };

    aliases = {
      st = "status -sb";
      co = "checkout";
      br = "branch";
      ci = "commit";
      lg = "log --oneline --graph --decorate --all";
    };
  };

  programs.lazygit.enable = true;

  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
  };
}
