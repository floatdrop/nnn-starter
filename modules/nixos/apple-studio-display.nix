{
  pkgs,
  lib,
  username,
  ...
}: {
  # Apple Studio Display brightness control.
  #
  # The display has no physical buttons and doesn't speak DDC/CI — brightness is
  # only settable by sending USB-HID reports, so the usual `brightnessctl` (which
  # drives the internal panel's backlight class device) can't see it. `asdbctl`
  # (`get`/`set`/`up`/`down`) talks to the HID device; its bundled udev rule tags
  # the node `uaccess`, so the logged-in user controls it without root.
  #
  # Don't have a Studio Display? Comment this module out of ./default.nix — that
  # removes the package + udev rule and reverts the brightness keys to the
  # internal-panel-only binds in ../home/niri.nix.
  environment.systemPackages = [pkgs.asdbctl];
  services.udev.packages = [pkgs.asdbctl];

  # Override the internal-only brightness binds (../home/niri.nix) to drive the
  # laptop panel and the Studio Display together. asdbctl exits harmlessly when
  # no display is attached, so the keys work whether docked or not.
  home-manager.users.${username}.programs.niri.settings.binds = {
    "XF86MonBrightnessUp" =
      lib.mkForce {action.spawn = ["sh" "-c" "brightnessctl set 5%+; asdbctl up"];};
    "XF86MonBrightnessDown" =
      lib.mkForce {action.spawn = ["sh" "-c" "brightnessctl set 5%-; asdbctl down"];};
  };
}
