{ config, pkgs, ... }:

{
  imports = [
    ./homebrew.nix
  ];

  # Set the primary user for homebrew and other user-specific options
  system.primaryUser = "prof";

  # Disable nix-darwin's Nix management (using Determinate Nix)
  nix.enable = false;

  # Used for backwards compatibility
  system.stateVersion = 5;
}
