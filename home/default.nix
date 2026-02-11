{ config, pkgs, ... }:

{
  imports = [
    ./zsh.nix
    ./git.nix
    ./packages.nix
    ./aerospace.nix
  ];

  # Basic home-manager settings
  home.username = "prof";
  home.homeDirectory = "/Users/prof";
  home.stateVersion = "24.11";

  # Let home-manager manage itself
  programs.home-manager.enable = true;
}
