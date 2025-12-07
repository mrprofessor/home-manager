{ config, pkgs, ... }:

{
  # Homebrew configuration
  nix-homebrew = {
    enable = true;
    user = "prof";
    autoMigrate = true;
  };

  homebrew = {
    enable = true;

    # Custom taps
    taps = [
      "d12frosted/emacs-plus"
      "nikitabobko/tap"
    ];

    # CLI tools via brew
    brews = [
      "jq"
      "gh"
      "uv"
      "mpv"               # Emacs multimedia
      "ripgrep"           # Faster grep
      "bufbuild/buf/buf"  # protobuf generation

      "neovim"            # Neovim
      "emacs-plus"        # Emacs

      "nvm"               # Node Version Manager
    ];

    # GUI apps via casks
    casks = [
      "zed"
      "iterm2"

      "discord"
      "microsoft-teams"
      "brave-browser"

      "claude-code"
      "nikitabobko/tap/aerospace"
    ];

    # Automatically update homebrew and upgrade packages
    onActivation = {
      autoUpdate = true;
      upgrade = true;
    };
  };
}
