{ pkgs, ... }:
let
  pkgsUnstable = import <nixpkgs-unstable> { };
in
{
  systemd.services."failure-notification" = {
    enable = false;
    serviceConfig = {
      Description = "Send a notification about a failed systemd unit";
      ExecStart = "/etc/nixos/notify-failure.sh %i";
      EnvironmentFile = config.age.secrets.pop.path;
    };

    path = [
      pkgsUnstable.pop
    ];

    after = [
      "network-online.target"
    ];
  };
}

