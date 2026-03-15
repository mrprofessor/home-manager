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

## Shell Startup Optimizations

`zsh.nix` inlines several slow shell init scripts as static exports for faster startup:

- **Homebrew** — static `HOMEBREW_PREFIX` etc. instead of `eval $(brew shellenv)`
- **Nix** — static `NIX_PROFILES`, `NIX_SSL_CERT_FILE`, `PATH` instead of sourcing `nix-daemon.sh`
- **NVM** — lazy-loaded via wrapper functions, only sources `nvm.sh` on first use of `nvm`/`node`/`npm`/`npx`

If any of these change (e.g. nix profile path, SSL cert location, homebrew prefix), the static values in `zsh.nix` need to be updated manually.
