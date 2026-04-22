{ config, pkgs, ... }:

{
  imports = [
    ./zsh.nix
    ./git.nix
    ./packages.nix
    ./aerospace.nix
    ./neovim.nix
    ./tmux.nix
  ];

  # Basic home-manager settings
  home.username = "prof";
  home.homeDirectory = "/Users/prof";
  home.stateVersion = "24.11";

  # Native config files
  home.file.".config/ghostty/config".source = ./ghostty/config;

  # Let home-manager manage itself
  programs.home-manager.enable = true;
}
