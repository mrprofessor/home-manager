{ config, pkgs, ... }:

{
  imports = [
    ./zsh.nix
    ./git.nix
    ./packages.nix
    ./agents.nix
    ./codex.nix
    ./claude-code.nix
    ./aerospace.nix
    ./neovim.nix
    ./tmux.nix
    ./direnv.nix
    ./emacs.nix
    ./ghostty.nix
    ./herdr.nix
  ];

  # Basic home-manager settings
  home.username = "prof";
  home.homeDirectory = "/Users/prof";
  home.stateVersion = "24.11";

  # Let home-manager manage itself
  programs.home-manager.enable = true;
}
