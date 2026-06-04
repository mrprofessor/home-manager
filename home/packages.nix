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

    # Kubernetes (local cluster for the ~/labs/platform lab)
    kind
    kubectl
  ];
}
