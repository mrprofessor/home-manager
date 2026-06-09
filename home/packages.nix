{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Programming languages
    python312
    python312Packages.virtualenv

    # CLI tools
    git
    ripgrep
    fzf
    jq
    hyperfine # statistical shell-startup benchmarking
    moreutils # `ts` for timestamped `zsh -ixc exit` traces

    # Kubernetes (local cluster for the ~/labs/platform lab)
    kind
    kubectl
  ];
}
