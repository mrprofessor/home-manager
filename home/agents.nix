{ config, pkgs, lib, ... }:

let
  # Personal skills, defined once in home/agents/skills.nix (shared with Claude).
  sharedSkills = import ./agents/skills.nix;
in
{
  # Shared agent-facing files.
  #
  # Human-authored guidance lives under home/agents/ so Codex, Claude, and
  # other agent CLIs share one source. Tool-specific runtime state stays in
  # each tool's own config dir (never managed here).
  home.file = {
    # Canonical guidance home (~/.agents) plus the copy Codex actually reads.
    # ~/.claude/CLAUDE.md is handled by claude-code.nix's memory.source.
    ".agents/AGENTS.md".source = ./agents/AGENTS.md;
    ".codex/AGENTS.md".source = ./agents/AGENTS.md;
  }
  # Fan the shared skills into ~/.codex/skills/<name>/ (Codex reads these
  # alongside its own builtins under ~/.codex/skills/.system/).
  // lib.mapAttrs'
    (name: path: lib.nameValuePair ".codex/skills/${name}" { source = path; })
    sharedSkills;
}
