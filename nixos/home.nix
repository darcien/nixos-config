{ config, pkgs, ... }:

let

  # TODO: write about nix channel per user?
  # https://nix-community.github.io/home-manager/index.html#_how_do_i_install_packages_from_nixpkgs_unstable
  pkgsUnstable = import <nixpkgs-unstable> { };

in

{

  imports = [
    "${fetchTarball "https://github.com/msteen/nixos-vscode-server/tarball/master"}/modules/vscode-server/home.nix"

    ./apps/git.nix
    ./apps/lsd.nix
    ./apps/mcfly.nix
    ./apps/micro.nix
    ./apps/starship.nix
    ./apps/zsh.nix
  ];

  home.username = "darcien";
  home.homeDirectory = "/home/darcien";

  home.stateVersion = "22.11";

  home.packages = with pkgs; [
    pkgsUnstable.deno
    pkgsUnstable.hugo
    pkgsUnstable.just
    pkgsUnstable.openssl
  ];

  services.vscode-server.enable = true;

}
