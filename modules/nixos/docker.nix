{username, ...}: {
  # Docker daemon + CLI (`docker`, `docker compose`).
  virtualisation.docker = {
    enable = true;

    # Reclaim disk from dangling images/containers/volumes weekly, mirroring the
    # Nix store GC in ./default.nix. Without this, stale image layers pile up
    # unbounded until they eat the disk.
    autoPrune = {
      enable = true;
      dates = "weekly";
    };

    # Use the classic overlay2 image store instead of the containerd snapshotter
    # (Docker 29's default). Under the containerd store, cAdvisor's docker
    # handler can't resolve container names, so containers lose their `name`
    # label and per-container CPU/mem dashboards (see the zoxy-benchmark
    # monitoring stack) go blank.
    daemon.settings.features.containerd-snapshotter = false;
  };

  # Let the user drive Docker without sudo. NOTE: membership in the `docker`
  # group is root-equivalent (you can bind-mount `/` into a container as root),
  # so this trades isolation for convenience — the same trade this config
  # already makes with passwordless sudo in ./users.nix. Want real isolation?
  # Drop this line and switch to `virtualisation.docker.rootless` instead.
  users.users.${username}.extraGroups = ["docker"];
}
