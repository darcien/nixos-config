{ lib, ... }: {
  # This file was populated at runtime with the networking
  # details gathered from the active system.

  # https://tailscale.com/kb/1063/install-nixos/
  # start service: `sudo tailscale up --ssh --advertise-exit-node`
  services.tailscale.enable = true;
  networking.nameservers = [ "100.100.100.100" "8.8.8.8" "1.1.1.1" ];
  networking.search = [ "capybara-panga.ts.net" ];

  # Fix "warning: Strict reverse path filtering breaks Tailscale exit node use and some subnet routing setups."
  networking.firewall.checkReversePath = "loose";

  networking.firewall.allowedUDPPorts = [
    53 # DNS
  ];

  # Enable IP forwarding for Tailscale exit node
  # https://tailscale.com/kb/1019/subnets/?tab=linux#enable-ip-forwarding
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = 1;

  # Getting high CPU usage from tailscaled
  # when using MagicDNS with no systemd-networkd.
  # https://github.com/tailscale/tailscale/issues/8563
  systemd.network.enable = true;

  # Fix `Timeout occurred while waiting for network connectivity.` error
  # when rebuilding.
  # Seems to be stuck waiting on eth1 to be up.
  # https://github.com/tailscale/tailscale/issues/8563#issuecomment-1640334455
  # https://github.com/NixOS/nixpkgs/issues/180175#issuecomment-1473408913
  systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;

  networking = {
    defaultGateway = "167.172.64.1";
    defaultGateway6 = {
      address = "2400:6180:0:d0::1";
      interface = "eth0";
    };
    dhcpcd.enable = false;
    usePredictableInterfaceNames = lib.mkForce false;
    interfaces = {
      eth0 = {
        ipv4.addresses = [
          { address = "167.172.75.254"; prefixLength = 20; }
          { address = "10.15.0.6"; prefixLength = 16; }
        ];
        ipv6.addresses = [
          { address = "2400:6180:0:d0::148b:1"; prefixLength = 64; }
          { address = "fe80::b446:16ff:feb4:4f28"; prefixLength = 64; }
        ];
        ipv4.routes = [{ address = "167.172.64.1"; prefixLength = 32; }];
        ipv6.routes = [{ address = "2400:6180:0:d0::1"; prefixLength = 128; }];
      };

    };
  };

  services.udev.extraRules = ''
    ATTR{address}=="b6:46:16:b4:4f:28", NAME="eth0"
    ATTR{address}=="5e:f8:d7:5b:c8:ba", NAME="eth1"
  '';
}
