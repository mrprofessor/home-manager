{ config, pkgs, ... }:

{
  programs.fish = {
    enable = true;

    loginShellInit = ''
      # Set up Nix
      if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
        source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
      end
    '';

    shellAliases = {
      # Home Manager aliases
      hm-switch = "nix run home-manager/master -- switch --flake ~/.config/home-manager";
      hm-update = "cd ~/.config/home-manager && nix flake update && nix run home-manager/master -- switch --flake ~/.config/home-manager";

      # Darwin/System aliases - use full commands
      darwin-switch = "sudo -E nix run nix-darwin -- switch --flake ~/.config/home-manager#my-mac";
      darwin-update = "cd ~/.config/home-manager && nix flake update && sudo -E nix run nix-darwin -- switch --flake ~/.config/home-manager#my-mac";

      # Combined update
      nix-update = "cd ~/.config/home-manager && nix flake update && nix run home-manager/master -- switch --flake ~/.config/home-manager && sudo -E nix run nix-darwin -- switch --flake ~/.config/home-manager#my-mac";

      # Edit flake
      nix-edit = "nvim ~/.config/home-manager/flake.nix";
    };
  };
}
