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
      "jq"
      "gh"
      "uv"
      "mpv"                       # Emacs multimedia
      "ripgrep"                   # Faster grep
      "bufbuild/buf/buf"          # Protobuf generation
      "neovim"                    # Neovim
      "opencode"                  # LLMs + CLI
      "nvm"                       # Node Version Manager
      "typst"                     # Latex but better
      "temporal"                  # Work stuff
      "siderolabs/tap/talosctl"   # Talos for kubernetes
    ];

    # GUI apps via casks
    casks = [
      "zed"
      "iterm2"
      "discord"
      "microsoft-teams"
      "brave-browser"
      "orbstack"                  # Docker alternative
      "bruno"                     # Postman alternative
      "freelens"                  # K8s IDE
      "claude-code"               # Claude CLI
      "codex"                     # Open AI CLI
      "nikitabobko/tap/aerospace"
    ];

    # Automatically update homebrew and upgrade packages
    onActivation = {
      autoUpdate = true;
      upgrade = true;
    };
  };
}
