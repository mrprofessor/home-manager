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
      "nikitabobko/tap"
    ];

    # CLI tools via brew
    brews = [
      "gh"
      "uv"
      "mpv"        # Emacs multimedia
      "ripgrep"    # Faster grep
      "neovim"
    ];

    # GUI apps via casks
    casks = [
      # Terms and editors
      "iterm2"
      "zed"

      # Social media
      "discord"
      "microsoft-teams"
      "brave-browser"

      # Tools
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
