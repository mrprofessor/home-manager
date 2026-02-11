{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;

    enableCompletion = true;
    autosuggestion.enable = true;
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
      hm-switch = "nix run home-manager/master -- switch --flake ~/.config/home-manager";
      hm-update = "cd ~/.config/home-manager && nix flake update && nix run home-manager/master -- switch --flake ~/.config/home-manager";

      # Darwin/System aliases
      darwin-switch = "sudo -E nix run nix-darwin -- switch --flake ~/.config/home-manager#my-mac";
      darwin-update = "cd ~/.config/home-manager && nix flake update && sudo -E nix run nix-darwin -- switch --flake ~/.config/home-manager#my-mac";

      # Combined update
      nix-update = "cd ~/.config/home-manager && nix flake update && nix run home-manager/master -- switch --flake ~/.config/home-manager && sudo -E nix run nix-darwin -- switch --flake ~/.config/home-manager#my-mac";

      # Edit flake
      nix-edit = "zed ~/.config/home-manager/";
    };
  };

  # Fast prompt (replaces oh-my-zsh robbyrussell theme)
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  xdg.configFile."starship.toml".text = ''
    format = "$username$directory$git_branch$git_status$character"

    [username]
    show_always = true
    format = "[$user](green) "

    [directory]
    format = "[$path](bold cyan) "
    truncation_length = 0
    truncate_to_repo = false
    fish_style_pwd_dir_length = 0

    [git_branch]
    format = "[($branch)](yellow)"

    [git_status]
    modified = "*"
    format = "[$all_status$ahead_behind](red) "

    [character]
    success_symbol = "[\\$](green)"
    error_symbol = "[\\$](red)"
  '';

  # Smart cd (replaces oh-my-zsh z plugin)
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}
