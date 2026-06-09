{ config, pkgs, ... }:

{
  # Config-light management of Codex.
  #
  # The binary itself stays on Homebrew (codex cask) so it tracks upstream
  # releases with no Nix lag -- hence `package = null`.
  #
  # Do not manage `settings` here. Codex rewrites ~/.codex/config.toml at
  # runtime for model, MCP, plugins, trust, UI state, and other local settings.
  programs.codex = {
    enable = true;
    package = null;
  };
}
