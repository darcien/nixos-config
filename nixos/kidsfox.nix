{ pkgs, config, ... }:
let
  pkgsUnstable = import <nixpkgs-unstable> { };
  silverbulletDir = "/home/darcien/projects/kidsfox/";
in
{
  # This service is using pelorperak.nix as template
  # for separating personal and kf SB instance.
  systemd.services.kidsfox = {
    enable = true;
    serviceConfig = {
      ExecStart = "/home/darcien/.deno/bin/silverbullet ${silverbulletDir}space/";
      WorkingDirectory = silverbulletDir;

      Restart = "on-failure";

      # Run service as user and group,
      # otherwise it will default as root user
      User = "darcien";
      Group = "users";

      EnvironmentFile = config.age.secrets.kidsfox.path;
    };

    environment = {
      SB_PORT = "5252";
    };

    path = [
      pkgsUnstable.deno
      # Expose git and ssh for sync with GitHub repo (via git plug)
      pkgs.git
      pkgs.openssh
    ];

    wants = [
      "network-online.target"
    ];
    after = [
      "network-online.target"
    ];
    wantedBy = [ "multi-user.target" ];
  };
}

