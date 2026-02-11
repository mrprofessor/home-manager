# MacOS Nix Configuration

## Structure

```
~/.config/home-manager/
├── flake.nix              # Main flake configuration
├── flake.lock
├── home/
│   ├── default.nix        # Home-manager base config
│   ├── zsh.nix           # Zsh shell config + aliases
│   ├── git.nix            # Git config
│   ├── packages.nix       # Nix packages
│   └── aerospace.nix      # Aerospace window manager
└── darwin/
    ├── default.nix        # nix-darwin entry point
    ├── homebrew.nix       # Homebrew packages (brews, casks, taps)
    └── post-install.nix   # macOS system settings (Dock, Finder, etc.)
```

## Commands

```bash
# Home Manager
hm-switch        # Apply home-manager configuration
hm-update        # Update flake inputs and apply

# Darwin
darwin-switch    # Apply system/homebrew configuration
darwin-update    # Update flake inputs and apply

# Combined
nix-update       # Update everything (flake + home-manager + darwin)

# Edit
nix-edit         # Open ~/.config/home-manager/ in Zed
```
