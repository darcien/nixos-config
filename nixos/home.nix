{ config, pkgs, ... }:

let

  # TODO: write about nix channel per user?
  # https://nix-community.github.io/home-manager/index.html#_how_do_i_install_packages_from_nixpkgs_unstable
  pkgsUnstable = import <nixpkgs-unstable> { };

in

{

  imports = [
    ./apps/git.nix
    ./apps/mcfly.nix
    ./apps/micro.nix
    ./apps/starship.nix
    ./apps/zsh.nix
  ];

  home.username = "darcien";
  home.homeDirectory = "/home/darcien";

  home.stateVersion = "22.11";

  home.packages = with pkgs; [
    pkgsUnstable.hugo
    pkgsUnstable.just
  ];

}
