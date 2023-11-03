{ pkgs, config, ... }:

let

  pkgsUnstable = import <nixpkgs-unstable> { };

in

{
  services.uptime-kuma = {
    enable = true;

    # need upstream support to allow tailscale ping
    # https://github.com/louislam/uptime-kuma/issues/1981
    # https://github.com/NixOS/nixpkgs/blob/945559664c1dc5836173ee12896ba421d9b37181/nixos/modules/services/monitoring/uptime-kuma.nix#L55
    # path = [
    #   pkgs.tailscale
    #   pkgsUnstable.tailscale
    # ];
  };
}
