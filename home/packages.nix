{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Programming languages
    go
    python312
    python312Packages.virtualenv

    # CLI tools
    git
    ripgrep
    fzf
    jq
  ];
}
