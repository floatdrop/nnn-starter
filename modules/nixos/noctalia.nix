{
  pkgs,
  inputs,
  ...
}: {
  # Noctalia's NixOS module enables the system-level support it needs. The shell
  # itself is launched per-user from home (see modules/home/noctalia.nix), so we
  # only opt into the recommended companion services here.
  programs.noctalia = {
    enable = true;
    recommendedServices.enable = true;
    # Use upstream's prebuilt package straight from noctalia.cachix.org instead
    # of rebuilding the (large, ~hour) C++ tree against our nixpkgs.
    package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
  };
}
