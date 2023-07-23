{ pkgs, ... }:
let
  pkgsUnstable = import <nixpkgs-unstable> { };
  silverbulletDir = "/home/darcien/projects/pelorperak/";
in
{
  # After rebuild, do:
  # 1. Start the service, check its working or not
  # sudo systemctl start pelorperak
  # 2. If it's working, enable it
  # sudo systemctl enable pelorperak

  # Not using user services as they get killed after a while
  # if user is not logged in.

  systemd.services.pelorperak = {
    enable = true;
    serviceConfig = {
      ExecStart = "/home/darcien/.deno/bin/silverbullet --auth=${silverbulletDir}.auth.json ${silverbulletDir}space/";
      WorkingDirectory = silverbulletDir;

      Restart = "on-failure";

      # Run service as user and group,
      # otherwise it will default as root user
      User = "darcien";
      Group = "users";
    };

    environment = {
      SB_PORT = "3000";
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

