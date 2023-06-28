{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
    ./ssh.nix

    <home-manager/nixos>

    # TODO: Move to home manager
    # https://github.com/nix-community/nixos-vscode-server#enable-the-service
    (fetchTarball "https://github.com/nix-community/nixos-vscode-server/tarball/master")
  ];

  boot.cleanTmpDir = true;
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
    htop
    wget
    nixpkgs-fmt # https://github.com/nix-community/nixpkgs-fmt#installation
  ];

  services.vscode-server.enable = true;

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
