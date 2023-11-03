{ pkgs, ... }:

let
  pkgsUnstable = import <nixpkgs-unstable> { };

  pelorperakUrl = "http://127.0.0.1:3000";
  kfSilverbulletUrl = "http://127.0.0.1:5252";
  uptimeKumaUrl = "http://127.0.0.1:3001";

  proxy = url: {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = url;
      proxyWebsockets = true;
    };
  };
in

{

  # Just use default version,
  # using custom one can have build failures on some additional modules.
  # e.g. `symbol lookup error` with brotli turned on.
  # services.nginx.package = pkgsUnstable.nginxMainline;

  security.acme = {
    acceptTerms = true;
    defaults.email = "shigure+acme@darcien.me";
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedBrotliSettings = true;
    clientMaxBodySize = "1024m";

    # ref https://github.com/NULLx76/infrastructure/blob/5a26864eafc11f6535c53248919ff296f3ed941a/nixos/hosts/hades/nginx/configuration.nix#L62
    virtualHosts."s3.darcien.dev" = proxy "http://127.0.0.1:3900";

    virtualHosts."pelorperak.darcien.dev" = proxy pelorperakUrl;
    virtualHosts."pp.darcien.dev" = proxy pelorperakUrl;

    virtualHosts."kidsfox.darcien.dev" = proxy kfSilverbulletUrl;
    virtualHosts."kf.darcien.dev" = proxy kfSilverbulletUrl;
    # https://👶🦊.darcien.dev (emoji -> punnycode)
    virtualHosts."xn--4q8hi5f.darcien.dev" = proxy kfSilverbulletUrl;

    # status pages
    # https://github.com/louislam/uptime-kuma/wiki/Status-Page
    virtualHosts."status.kf.darcien.dev" = proxy uptimeKumaUrl;
    virtualHosts."status.darcien.dev" = proxy uptimeKumaUrl;
  };

}
