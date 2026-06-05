{ config, pkgs, ... }:

{
  # Config-only management of Claude Code.
  #
  # The binary itself stays on Homebrew (claude-code@latest cask) so it tracks
  # upstream releases with no Nix lag -- hence `package = null`.
  #
  # settings.json is intentionally NOT managed here: Claude Code rewrites it at
  # runtime (/model, /effort, /config, theme toggles), and the module would make
  # it a read-only Nix-store symlink. The module only writes settings.json when
  # `settings` is non-empty, so leaving it unset keeps ~/.claude/settings.json
  # hand-managed and writable. Likewise ~/.claude.json is runtime state -- never
  # manage it.
  #
  # Static, never-mutated-by-CC files are the good fit for Nix. Keep them under
  # home/claude/ (matching the home/<tool>/ convention used by ghostty, nvim,
  # tmux, etc.) and reference them by relative path. Add them as the need arises:
  #
  #   memory.source   = ./claude/CLAUDE.md;          # -> ~/.claude/CLAUDE.md
  #   agents.<name>   = ./claude/agents/<name>.md;    # -> ~/.claude/agents/<name>.md
  #   commands.<name> = ./claude/commands/<name>.md;
  #   hooks.<name>    = ''...'';
  #   skills.<name>   = ./claude/skills/<name>;
  programs.claude-code = {
    enable = true;
    package = null;

    # Global user memory -> ~/.claude/CLAUDE.md (read-only Nix symlink).
    memory.source = ./claude/CLAUDE.md;

    # Personal skills -> ~/.claude/skills/<name>/.
    skills.nix-home-manager = ./claude/skills/nix-home-manager;

    # Obsidian skills (vendored from kepano/obsidian-skills, MIT; see
    # OBSIDIAN-SKILLS-LICENSE.txt). Vault: hivemind. Editing notes + Bases.
    skills.obsidian-markdown = ./claude/skills/obsidian-markdown;
    skills.obsidian-bases = ./claude/skills/obsidian-bases;
    skills.obsidian-cli = ./claude/skills/obsidian-cli;
  };
}
