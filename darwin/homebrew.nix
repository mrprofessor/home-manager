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
      "atlassian/acli"
    ];

    # CLI tools via brew
    brews = [
      "go"
      "jq"
      "gh"
      "uv"
      "tmux"
      "mpv"                       # Emacs multimedia
      "ripgrep"                   # Faster grep
      "nvm"                       # Node Version Manager
      "typst"                     # Latex but better
      "pngpaste"                  # Paste images from clipboard
      "podman"                    # Container runtime
      "atlassian/acli/acli"       # Atlassian client
    ];

    # GUI apps via casks
    casks = [
      "zed"
      "iterm2"
      "discord"
      "microsoft-teams"
      "brave-browser"
      "raycast"
      "orbstack"                  # Docker alternative
      "bruno"                     # Postman alternative
      "freelens"                  # K8s IDE
      "claude-code"               # Claude CLI
      "codex"                     # OpenAI Codex CLI
      "nikitabobko/tap/aerospace" # MacOS windows manager
    ];

    # Automatically update homebrew and upgrade packages
    onActivation = {
      autoUpdate = true;
      upgrade = true;
    };
  };
}
