{ config, pkgs, ... }:

let
  # Personal skills, defined once in home/agents/skills.nix.
  sharedSkills = import ./agents/skills.nix;
in
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
  # Static, never-mutated-by-CC files are the good fit for Nix. All shared
  # agent source (guidance + skills) lives under home/agents/. Anything
  # Claude-specific would go in its own dir, e.g.:
  #
  #   agents.<name>   = ./claude/agents/<name>.md;    # -> ~/.claude/agents/<name>.md
  #   commands.<name> = ./claude/commands/<name>.md;
  #   hooks.<name>    = ''...'';
  programs.claude-code = {
    enable = true;
    package = null;

    # Global user memory -> ~/.claude/CLAUDE.md (read-only Nix symlink).
    # The source is shared with Codex and other agent CLIs via ~/.agents.
    memory.source = ./agents/AGENTS.md;

    # Personal skills -> ~/.claude/skills/<name>/. Sourced from the single
    # list in home/agents/skills.nix (shared with Codex). Obsidian skills are
    # vendored from kepano/obsidian-skills (MIT; see OBSIDIAN-SKILLS-LICENSE.txt).
    skills = sharedSkills;
  };
}
