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
      "ariga/homebrew-tap"
    ];

    # CLI tools via brew
    brews = [
      # Languages / runtimes
      "go"
      "uv"                        # Python package manager
      "nvm"                       # Node Version Manager
      "hugo"                      # Static blogging tool 

      # Shell / CLI utilities
      "jq"
      "ripgrep"                   # Faster grep
      "terminal-notifier"         # Native macOS notifications
      "herdr"                     # Agentic tmux

      # Dev / DevOps
      "gh"                        # GitHub CLI
      "jj"                        # Supposedly better git 
      "podman"                    # Docker work stuff
      "atlassian/acli/acli"       # Atlassian client
      "ariga/tap/atlas"           # Atlas-go


      # Media / Misc
      "mpv"                       # Emacs multimedia
      "pngpaste"                  # Paste images from clipboard
      "typst"                     # Latex but better
    ];

    # GUI apps via casks
    casks = [
      # Editors / IDEs
      "zed"                       # Goated text editor fr
      "visual-studio-code"        # Until Zed support notebooks/pdfs

      # Terminal
      "ghostty"                   # GPU-accelerated terminal

      # AI / Coding tools
      "claude-code@latest"        # Claude CLI (fast-updating channel)
      "codex"                     # OpenAI Codex CLI

      # Browsers
      "brave-browser"

      # Containers / DevOps
      "podman-desktop"            # Work license issue
      "freelens"                  # K8s IDE

      # API / Dev tools
      "bruno"                     # Postman alternative
      "dbeaver-community"         # Postgres GUI

      # Productivity / Communication
      "raycast"
      "obsidian"
      "discord"
      "microsoft-teams"

      # Window management
      "nikitabobko/tap/aerospace" # MacOS windows manager
    ];

    # Automatically update homebrew and upgrade packages
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      # Preserve manually installed formulae such as emacs-plus.
      cleanup = "none";
    };
  };
}
