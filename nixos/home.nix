{ config, pkgs, ... }:

let
  pkgsUnstable = import <nixpkgs-unstable> { };
in

{

  imports = [
    "${fetchTarball "https://github.com/msteen/nixos-vscode-server/tarball/master"}/modules/vscode-server/home.nix"

    ./apps/btop.nix
    ./apps/git.nix
    ./apps/lazygit.nix
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
