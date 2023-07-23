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
      Restart = "on-failure";
    };

    environment = {
      SB_PORT = "3000";
    };

    path = [
      pkgsUnstable.deno
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

