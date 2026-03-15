{ config, pkgs, lib, ... }:

{
  imports = [
    ./homebrew.nix
    ./post-install.nix
  ];

  # Set the primary user for homebrew and other user-specific options
  system.primaryUser = "prof";

  # Disable nix-darwin's Nix management (using Determinate Nix)
  nix.enable = false;

  # Prevent /etc/zshrc from running redundant compinit + bashcompinit
  # (home-manager already handles completion)
  programs.zsh.enableGlobalCompInit = false;
  programs.zsh.enableBashCompletion = false;

  # Skip dynamic `brew shellenv` in /etc/zshrc (set statically in home-manager zsh.nix)
  programs.zsh.interactiveShellInit = lib.mkForce "";

  # Used for backwards compatibility
  system.stateVersion = 5;
}
