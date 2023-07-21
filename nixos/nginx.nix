{ pkgs, ... }:

let
  pkgsUnstable = import <nixpkgs-unstable> { };

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

  services.nginx.package = pkgsUnstable.nginxMainline;

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
    # Setting does not exist on current ver yet
    # recommendedBrotliSettings = true;
    clientMaxBodySize = "1024m";

    # ref https://github.com/NULLx76/infrastructure/blob/5a26864eafc11f6535c53248919ff296f3ed941a/nixos/hosts/hades/nginx/configuration.nix#L62
    virtualHosts."s3.darcien.dev" = proxy "http://127.0.0.1:3900";

    virtualHosts."pelorperak.darcien.dev" = proxy "http://127.0.0.1:3000";
    virtualHosts."pp.darcien.dev" = proxy "http://127.0.0.1:3000";
  };

}
