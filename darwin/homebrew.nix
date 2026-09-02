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
      "d12frosted/emacs-plus"
    ];

    # Homebrew 6 turned on HOMEBREW_REQUIRE_TAP_TRUST, so it refuses to load
    # formulae/casks from non-official taps until they are trusted. nix-darwin
    # only grew `trusted = true` on taps/brews/casks after the 25.11 branch, so
    # emit the Brewfile lines by hand until that lands here. `brew bundle`
    # applies every `trusted:` option before it resolves anything, so these are
    # fine at the bottom of the file. Repeating the taps above is harmless;
    # tapping is idempotent.
    extraConfig = ''
      tap "nikitabobko/tap", trusted: true
      tap "atlassian/acli", trusted: true
      tap "ariga/homebrew-tap", trusted: true
      tap "steipete/tap", trusted: true
      tap "d12frosted/emacs-plus", trusted: true
    '';

    # CLI tools via brew
    brews = [
      # Languages / runtimes
      "go"
      "uv" # Python package manager
      "nvm" # Node Version Manager
      "hugo" # Static blogging tool

      # Shell / CLI utilities
      "jq"
      "ripgrep" # Faster grep
      "terminal-notifier" # Native macOS notifications
      "herdr" # Agentic tmux

      # Dev / DevOps
      "gh" # GitHub CLI
      "podman" # Docker but nicer
      "azure-cli" # Talk to azure cloud
      "atlassian/acli/acli" # Atlassian client
      "ariga/tap/atlas" # Atlas-go

      # Editors. home/neovim.nix leans on nvim being on PATH.
      "neovim"

      # Media / Misc
      "mpv" # Emacs multimedia
      "pngpaste" # Paste images from clipboard
      "typst" # Latex but better

      # Emacs. No args: the formula hardcodes --with-native-compilation=aot,
      # and the icon is picked in home/emacs-plus/build.yml, which the formula
      # reads directly. There is no CLI flag for it.
      "d12frosted/emacs-plus/emacs-plus@30"

      # Found installed but undeclared when cleanup was switched on. Declared
      # so nothing vanished by surprise; delete a line and dws removes it.
      "glow" # Markdown in the terminal
    ];

    # GUI apps via casks
    casks = [
      # Editors / IDEs
      "zed" # Goated text editor fr

      # Terminal
      "ghostty" # GPU-accelerated terminal

      # AI / Coding tools<D-s>
      "claude-code@latest" # Claude CLI (fast-updating channel)
      "codex" # OpenAI Codex CLI
      "steipete/tap/codexbar" # Usage bar

      # Browsers
      "brave-browser"

      # Containers / DevOps
      "freelens" # K8s IDE
      "orbstack" # I keep coming back to orbs

      # API / Dev tools
      "bruno" # Postman alternative

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
      # Anything brew has that is not declared above gets uninstalled on
      # dws, taps included. Keep this file the source of truth.
      #
      # Not via `cleanup = "uninstall"`: this nix-darwin (25.11) turns that
      # into `brew bundle --cleanup`, which Homebrew 6 deprecated and now
      # rejects without `--force-cleanup`. nix-darwin master passes
      # `--force-cleanup` itself; until that lands here, do it by hand.
      cleanup = "none";
      extraFlags = [ "--force-cleanup" ];
    };
  };
}
