# macOS Nix Configuration

## Structure

```
~/.config/home-manager/
├── flake.nix              # Clean main flake
├── flake.lock
├── home/
│   ├── default.nix        # Home-manager base config
│   ├── fish.nix           # Fish shell config
│   ├── git.nix            # Git config
│   └── packages.nix       # Nix packages
└── darwin/
    ├── default.nix        # Darwin base config
    └── homebrew.nix       # Homebrew packages
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
nix-edit         # Open flake.nix in nvim
```
