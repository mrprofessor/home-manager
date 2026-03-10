{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;

    history = {
      size = 10000;
      save = 10000;
      ignoreDups = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      share = true;
    };

    enableCompletion = true;
    syntaxHighlighting.enable = true;

    # Cache compinit — only rebuild once a day
    completionInit = ''
      autoload -Uz compinit
      if [[ -f ~/.zcompdump && $(date +'%j') == $(stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null) ]]; then
        compinit -C
      else
        compinit
      fi
    '';

    initContent = ''
      # Set up Nix
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi

      # Add .local/bin to PATH for kiro-cli
      export PATH="$HOME/.local/bin:$PATH"

      # Lazy-load NVM — only sources nvm.sh on first use
      export NVM_DIR="$HOME/.nvm"
      _load_nvm() {
        unset -f nvm node npm npx
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
      }
      nvm()  { _load_nvm && nvm  "$@"; }
      node() { _load_nvm && node "$@"; }
      npm()  { _load_nvm && npm  "$@"; }
      npx()  { _load_nvm && npx  "$@"; }

      # Up/down arrow history search (replaces oh-my-zsh default)
      bindkey '^[[A' history-search-backward
      bindkey '^[[B' history-search-forward

      # Colored man pages (replaces oh-my-zsh colored-man-pages plugin)
      export LESS_TERMCAP_mb=$'\e[1;31m'
      export LESS_TERMCAP_md=$'\e[1;36m'
      export LESS_TERMCAP_me=$'\e[0m'
      export LESS_TERMCAP_se=$'\e[0m'
      export LESS_TERMCAP_so=$'\e[1;44;33m'
      export LESS_TERMCAP_ue=$'\e[0m'
      export LESS_TERMCAP_us=$'\e[1;32m'

    '';

    shellAliases = {
      # Git aliases (replaces oh-my-zsh git plugin)
      glog = "git log --oneline --decorate --graph";

      # Home Manager aliases
      hms = "nix run home-manager/master -- switch --flake ~/.config/home-manager";
      hmu = "cd ~/.config/home-manager && nix flake update && nix run home-manager/master -- switch --flake ~/.config/home-manager";

      # Darwin/System aliases
      dws = "sudo -E nix run nix-darwin -- switch --flake ~/.config/home-manager#my-mac";
      dwu = "cd ~/.config/home-manager && nix flake update && sudo -E nix run nix-darwin -- switch --flake ~/.config/home-manager#my-mac";

      # Combined update
      nxu = "cd ~/.config/home-manager && nix flake update && nix run home-manager/master -- switch --flake ~/.config/home-manager && sudo -E nix run nix-darwin -- switch --flake ~/.config/home-manager#my-mac";

      # Edit flake
      nxe = "nvim ~/.config/home-manager/";

      # Ghostty
      ghostty = "/Applications/Ghostty.app/Contents/MacOS/ghostty";
    };
  };

  # Fast prompt (replaces oh-my-zsh robbyrussell theme)
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  xdg.configFile."starship.toml".source = ./starship/starship.toml;

  # Smart cd (replaces oh-my-zsh z plugin)
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}
