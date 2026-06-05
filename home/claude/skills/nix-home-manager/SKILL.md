---
name: nix-home-manager
description: Use when editing this user's Nix flake at ~/.config/home-manager (home-manager + nix-darwin on aarch64-darwin). Covers adding packages, new modules, managed dotfiles, Homebrew, applying with hms/dws/nxu, and the git-tracked-files gotcha. Triggers on edits under ~/.config/home-manager, "add a package", "manage X with home-manager", "new home-manager module", "rebuild/switch my nix config", any mention of hms/dws/nxu, or a "path is not tracked by git" eval error.
allowed-tools: Bash(nix:*) Bash(git:*) Bash(ls:*) Read Edit Write
---

# nix-home-manager

Flake at `~/.config/home-manager`, aarch64-darwin. Outputs
`homeConfigurations.prof` (user env) and `darwinConfigurations.my-mac` (system +
Homebrew). Channels: nixpkgs pinned, home-manager and nix-darwin on `25.11`.

## Golden rule: stage before you build

**Flakes only see git-tracked files. `git add` every new file BEFORE building or
switching, or eval dies with "path X is not tracked by git".** You need not
commit, just stage. The "Git tree is dirty" warning is harmless and expected.

**Why:** flake evaluation reads from the git tree, not the working dir, so an
untracked `home/foo.nix` is invisible and the import fails confusingly.

## Layout

- `home/default.nix` imports the modular `home/*.nix` files.
- Per-tool raw config lives in `home/<tool>/` (e.g. `home/ghostty/config`,
  `home/nvim/init.lua`), referenced by relative path from its module.
- `darwin/` holds system config: `default.nix`, `homebrew.nix`, `post-install.nix`.

## How to make a change

- **CLI package:** append to `home.packages` in `home/packages.nix`.
- **Homebrew app/cask:** edit `darwin/homebrew.nix`, then `dws`.
- **New module:** create `home/<name>.nix`, add `./<name>.nix` to `imports` in
  `home/default.nix`.
- **Managed dotfile:** drop the file in `home/<tool>/`, reference via the
  program's `*.source` option, `home.file."...".source`, or `xdg.configFile`.

## Apply (aliases in `home/zsh.nix`)

| alias | does |
|---|---|
| `hms` | switch home-manager |
| `dws` | switch nix-darwin (sudo) |
| `nxu` | flake update then switch both |
| `hmu` / `dwu` | update then switch that one |
| `nxe` | open the repo in nvim |

## Verify before switching

- Home: `nix build .#homeConfigurations.prof.activationPackage --no-link`
- System: `nix build .#darwinConfigurations.my-mac.system --no-link`

A clean build is the green light to switch.

## Gotchas

- Managed files become read-only Nix store symlinks. Edit the repo source and
  re-switch, never the live file in `$HOME`.
- Do not bump `home.stateVersion` casually; it pins state-migration behaviour.
- Commit only when asked. Never add Claude as a co-author.
