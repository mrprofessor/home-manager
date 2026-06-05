---
name: nix-home-manager
description: Manage this user's Nix flake config (home-manager + nix-darwin) at ~/.config/home-manager. Use when adding/removing packages, editing dotfiles managed by Nix, creating new home-manager modules, configuring Homebrew, or applying changes with hms/dws/nxu. Trigger on any edit under ~/.config/home-manager or requests like "add a package", "manage X with home-manager", "rebuild my nix config".
allowed-tools: Bash(nix:*) Bash(git:*) Bash(ls:*) Read Edit Write
---

# Nix home-manager (this machine)

Flake at `~/.config/home-manager` on aarch64-darwin. Channels: nixpkgs pinned,
home-manager `release-25.11`, nix-darwin `25.11`.

## Layout

- `flake.nix` outputs `homeConfigurations.prof` and `darwinConfigurations.my-mac`.
- `home/default.nix` imports the modular `home/*.nix` files (zsh, git, packages, etc.).
- `darwin/` holds system + Homebrew config (`default.nix`, `homebrew.nix`, `post-install.nix`).
- Raw (non-Nix) config files live in `home/<tool>/` (e.g. `home/ghostty/config`,
  `home/nvim/init.lua`) and are referenced by relative path from the module.

## Apply commands (aliases in `home/zsh.nix`)

- `hms` apply home-manager. `hmu` update flake then apply.
- `dws` apply nix-darwin (sudo). `dwu` update then apply.
- `nxu` update flake then apply both. `nxe` open the repo in nvim.

## How to make common changes

- Add a CLI package: append to `home.packages` in `home/packages.nix`.
- Add a Homebrew app/cask: edit `darwin/homebrew.nix`, then `dws`.
- New config module: create `home/<name>.nix`, add `./<name>.nix` to the
  `imports` list in `home/default.nix`.
- New managed dotfile: drop it in `home/<tool>/`, reference via the program's
  `*.source` option, `home.file`, or `xdg.configFile`.

## Rules

- Flakes only see git-tracked files. `git add` any new file BEFORE building, or
  you get "path X not tracked by git". The "Git tree is dirty" warning is harmless.
- Verify before switching: `nix build .#homeConfigurations.prof.activationPackage --no-link`.
- Home-manager-managed files become read-only Nix store symlinks. Edit the repo
  source and `hms`, never the live file in `$HOME`.
- Do not bump `home.stateVersion` casually.
- Commit only when asked. Never add Claude as a co-author.
