{local, ...}: {
  programs.git = {
    enable = true;

    settings = {
      # ⇩ Identity comes from local.nix.
      user.name = local.gitUserName;
      user.email = local.gitUserEmail;

      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      merge.conflictstyle = "zdiff3";
      diff.colorMoved = "default";

      alias = {
        st = "status -sb";
        co = "checkout";
        br = "branch";
        ci = "commit";
        lg = "log --oneline --graph --decorate --all";
      };
    };
  };

  # delta gives syntax-highlighted, side-by-side diffs (themed by Stylix).
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      line-numbers = true;
      side-by-side = true;
    };
  };

  programs.lazygit.enable = true;

  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
  };
}
