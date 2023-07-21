let
  pkgsUnstable = import <nixpkgs-unstable> { };
  silverbulletDir = "/home/darcien/projects/pelorperak/";
in
{
  # After rebuild, do:
  # 1. Start the service, check its working or not
  # systemctl --user start pelorperak
  # 2. If it's working, enable it
  # systemctl --user enable pelorperak

  # From https://github.com/nix-community/nixos-vscode-server
  # Enabling the user service creates a symlink to the Nix store,
  # but the linked store path could be garbage collected at some point.
  # One workaround to this particular issue is creating the following symlink:
  # ln -sfT /run/current-system/etc/systemd/user/pelorperak.service ~/.config/systemd/user/pelorperak.service
  systemd.user.services.pelorperak = {
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
    wantedBy = [ "default.target" ];
  };
}

