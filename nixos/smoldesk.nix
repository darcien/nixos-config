{ config, pkgs, ... }:
let
  pkgsUnstable = import <nixpkgs-unstable> { };
  smoldeskDir = config.users.users.darcien.home + "/projects/smoldesk/";
in
{

  systemd.timers.smoldesk = {
    # 2024-12-23, disabled, no more API access.
    enable = false;
    after = [
      "network-online.target"
    ];
    wants = [
      "network-online.target"
    ];
    wantedBy = [ "timers.target" ];

    timerConfig = {
      # https://man.archlinux.org/man/systemd.timer.5
      # Run timer 15m after boot
      OnBootSec = "15m";
      # Also run every 60m
      OnUnitActiveSec = "60m";
      Unit = "smoldesk.service";
    };
  };

  systemd.services.smoldesk = {
    script = ''
      set -eu
      # ${pkgsUnstable.deno}/bin/deno task debug
      ${pkgsUnstable.deno}/bin/deno task blast
    '';
    serviceConfig = {
      WorkingDirectory = smoldeskDir;
      Type = "oneshot";
      User = "darcien";
      Group = "users";
    };
  };

}

