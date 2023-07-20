{ config, ... }:

let

  pkgsUnstable = import <nixpkgs-unstable> { };

in

{
  networking.firewall.allowedTCPPorts = [ 3900 3901 3902 ];

  systemd.services.garage.serviceConfig.EnvironmentFile = config.age.secrets.garage.path;

  services.garage = {
    enable = true;
    package = pkgsUnstable.garage_0_8_2;

    settings = {
      db_engine = "lmdb";
      compression_level = 0;

      # For inter-node comms
      rpc_bind_addr = "[::]:3901";
      rpc_public_addr = "127.0.0.1:3901";

      # Standard S3 api endpoint
      s3_api = {
        s3_region = "garage";
        api_bind_addr = "[::]:3900";
        root_domain = ".s3.garage.localhost";
      };

      # Static file serve endpoint
      s3_web = {
        bind_addr = "[::]:3902";
        root_domain = ".web.garage.localhost";
        # index = "index.html";
      };
    };
  };

}
