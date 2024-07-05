{ pkgs, config, ... }:

let

  pkgsUnstable = import <nixpkgs-unstable> { };

in

{
  services.grafana = {
    enable = true;

    # declarativePlugins = with pkgs.grafanaPlugins; [ grafana-oncall-app ];

    settings = {
      server = {
        # Listening Address
        http_addr = "127.0.0.1";
        # and Port
        http_port = 3333;
        # Grafana needs to know on which domain and URL it's running
        # domain = "your.domain";
        # root_url = "https://your.domain/grafana/"; # Not needed if it is `https://your.domain/`
        serve_from_sub_path = true;

        enable_gzip = true;
      };
    };
  };
}
