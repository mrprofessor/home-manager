{ config, pkgs, ... }:

{
  programs.fish = {
    enable = true;

    # Override fish package to disable tests (they fail on macOS)
    package = pkgs.fish.overrideAttrs (oldAttrs: {
      doCheck = false;
    });

    loginShellInit = ''
      # Set up Nix
      if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
        source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
      end
    '';

    interactiveShellInit = ''
      # Disable welcome message
      set -g fish_greeting

      # Initialize Homebrew NVM
      if test -e /opt/homebrew/opt/nvm/nvm.sh
        set -gx NVM_DIR ~/.nvm
        mkdir -p $NVM_DIR
        # Load nvm using bass (bash to fish translator)
        function nvm
          bass source /opt/homebrew/opt/nvm/nvm.sh --no-use ';' nvm $argv
        end
      end

      # Hydro prompt colors
      set -g hydro_color_pwd purple
      set -g hydro_color_git yellow
      set -g hydro_color_error red
      set -g hydro_color_prompt cyan
      set -g hydro_symbol_git_dirty "*"
    '';

    plugins = [
      {
        name = "hydro";
        src = pkgs.fetchFromGitHub {
          owner = "jorgebucaran";
          repo = "hydro";
          rev = "main";
          sha256 = "sha256-QYq4sU41/iKvDUczWLYRGqDQpVASF/+6brJJ8IxypjE=";
        };
      }
    ];

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
      nix-edit = "zed ~/.config/home-manager/";
    };
  };
}
