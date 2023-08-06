{ pkgs, ... }:

let
  pkgsUnstable = import <nixpkgs-unstable> { };
in

{
  # Current home manager version don't have lazygit
  # need to upgrade first.
  # programs.lazygit = {
  #   enable = true;
  #   package = pkgsUnstable.lazygit;
  #   settings = { };
  # };
}
