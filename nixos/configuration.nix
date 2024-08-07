{ pkgs, ... }:
let
  pkgsUnstable = import <nixpkgs-unstable> { };
in
{
  imports = [
    "${builtins.fetchTarball "https://github.com/ryantm/agenix/archive/main.tar.gz"}/modules/age.nix"

    ./hardware-configuration.nix
    ./networking.nix
    ./ssh.nix
    ./age.nix
    # ./garage.nix
    # Disabling grafana for now,
    # current machine is not strong enough for running oncall dependencies.
    # ./grafana.nix
    # ./grafana-oncall.nix
    ./nginx.nix
    ./pelorperak.nix
    ./kidsfox.nix
    ./smoldesk.nix
    ./uptime-kuma.nix

    <home-manager/nixos>
  ];

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  system.stateVersion = "22.11";
  networking.hostName = "shigure";
  networking.domain = "";

  security.sudo.wheelNeedsPassword = false;

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];

  environment.systemPackages = with pkgs; [
    curl
    file
    htop
    lsof
    nixpkgs-fmt # https://github.com/nix-community/nixpkgs-fmt
    wget

    (pkgs.callPackage "${builtins.fetchTarball "https://github.com/ryantm/agenix/archive/main.tar.gz"}/pkgs/agenix.nix" { })

    pkgsUnstable.pop
  ];

  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-curses;
    enableSSHSupport = true;
  };

  users.users.darcien = {
    isNormalUser = true;
    home = "/home/darcien";
    extraGroups = [ "wheel" ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.darcien = import ./home.nix;
  };

}
