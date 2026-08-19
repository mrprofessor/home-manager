# Personal skills, shared across agent CLIs. Single source of truth.
#
# Add a skill here once; every consumer picks it up:
#   - claude-code.nix fans these into ~/.claude/skills/<name>
#   - agents.nix      fans these into ~/.codex/skills/<name>
#
# Paths resolve relative to this file, i.e. home/agents/skills/<name>.
{
  nix-home-manager = ./skills/nix-home-manager;
  orca-skill = ./skills/orca-skill;
  obsidian-markdown = ./skills/obsidian-markdown;
  obsidian-bases = ./skills/obsidian-bases;
  obsidian-cli = ./skills/obsidian-cli;
}
