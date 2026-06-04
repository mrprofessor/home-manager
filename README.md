# MacOS Nix Configuration

## Structure

```
~/.config/home-manager/
├── flake.nix              # Main flake configuration
├── flake.lock
├── home/
│   ├── default.nix        # Home-manager base config
│   ├── zsh.nix            # Zsh shell config + aliases
│   ├── git.nix            # Git config
│   ├── packages.nix       # Nix packages
│   ├── neovim.nix         # Neovim config
│   └── aerospace.nix      # Aerospace window manager
└── darwin/
    ├── default.nix        # nix-darwin entry point
    ├── homebrew.nix       # Homebrew packages (brews, casks, taps)
    └── post-install.nix   # macOS system settings (Dock, Finder, etc.)
```

## Commands

```bash
# Home Manager
hms              # Apply home-manager configuration
hmu              # Update flake inputs and apply

# Darwin
dws              # Apply system/homebrew configuration
dwu              # Update flake inputs and apply

# Combined
nxu              # Update everything (flake + home-manager + darwin)

# Edit
nxe              # Open config in nvim
```

## AeroSpace Window Manager

Config lives in `home/aerospace/aerospace.toml` (symlinked to `~/.aerospace.toml`
by `home/aerospace.nix`). Apps are pinned to workspaces, and workspaces are pinned
to monitors.

### Workspaces

| WS | Apps |
|----|------|
| 1  | Safari, Finder, Brave |
| 2  | Ghostty, iTerm, WezTerm |
| 3  | Emacs, Xcode |
| 4  | Preview, iBooks, DjVu, Raft |
| 5  | Zed |
| 6  | Codex, Claude, Bruno, Obsidian, Freelens |
| 7  | VSCode, Music, Elmedia |
| 8  | Slack, Teams |
| 9  | Discord |

### Monitor assignment

Both work monitors report the **same** name (`LS27D70xE`), so a name regex can't
tell them apart. Assignment uses AeroSpace's `main`/`secondary` keywords instead
(`secondary` only resolves when exactly 2 monitors are connected):

- **Work** (2 monitors, MacBook in clamshell):
  - Left **vertical** monitor = `secondary` → **Ghostty (WS 2)** + **Slack/Teams (WS 8)**
  - Right **horizontal** monitor = `main` → everything else
  - The right monitor must be set as **Main display** in *System Settings → Displays*.
    If left/right come out swapped, flip which display is Main — no config change needed.
- **Home** (1 external, clamshell): only one monitor, so `secondary` never matches
  and every workspace falls through to `main` / the `LS27` fallback → all apps land
  on the single external. The same config works in both places with no edits.

## Shell Startup Optimizations

`zsh.nix` inlines several slow shell init scripts as static exports for faster startup:

- **Homebrew** — static `HOMEBREW_PREFIX` etc. instead of `eval $(brew shellenv)`
- **Nix** — static `NIX_PROFILES`, `NIX_SSL_CERT_FILE`, `PATH` instead of sourcing `nix-daemon.sh`
- **NVM** — lazy-loaded via wrapper functions, only sources `nvm.sh` on first use of `nvm`/`node`/`npm`/`npx`

If any of these change (e.g. nix profile path, SSL cert location, homebrew prefix), the static values in `zsh.nix` need to be updated manually.
