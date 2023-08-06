{ ... }:

let
  legacyDesktopKey = ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOJLsatRyC4Ju4EGb1w8AWy/CycT4DcHnV5Hg7u5H+jj darcien@mika'';
  promea = ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPfdUhBoYPv6/1/dbtdw+H8YtHNFpszd8q1KzPt47WeC darcien@promea-2021-03-01'';
in

{
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  users.users.root.openssh.authorizedKeys.keys = [
    legacyDesktopKey
    promea
  ];

  users.users.darcien = {
    openssh.authorizedKeys.keys = [
      legacyDesktopKey
      promea
    ];
  };
}
