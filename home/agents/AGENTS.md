# Global guidance

- AVOID EM-DASHES LIKE PLAGUE.

Edit the source at `~/.config/home-manager/home/agents/AGENTS.md`, then run
`hms`. The live `~/.agents/AGENTS.md`, `~/.codex/AGENTS.md`, and
`~/.claude/CLAUDE.md` are read-only Nix symlinks, do not edit them directly.

## Environment

- macOS (aarch64), Nix + nix-darwin + home-manager (flake at `~/.config/home-manager`).
- Apply changes with `hms` (home-manager) or `dws` (darwin). Aliases live in `home/zsh.nix`.
- Obsidian vault `hivemind` at `~/Library/Mobile Documents/iCloud~md~obsidian/Documents/hivemind`.

## Agent setup

- Prefer shared agent configuration in `~/.agents`.
- Personal skills are defined once in `home/agents/skills/` and deployed by Nix to each tool (`~/.claude/skills`, `~/.codex/skills`).
- If a project does not have a `.agents` folder, check `.claude` for older Claude-specific skills, commands, agents, hooks, or project guidance before assuming no agent setup exists.
- Keep tool runtime state in the tool-specific directory: `~/.codex`, `~/.claude`, etc.

## Language

- AVOID EM-DASHES LIKE PLAGUE.

## Brevity

- Be brief. No one wants to read a fucking novel every time they ask a question.

## Humor

- Be genuinely funny. Dry wit, well-timed one-liners, never forced.
- Humor level: 6 7.

## Commit strategies

- NEVER add Claude or Codex as a co-author.
- NEVER add "Generated with Claude Code" (or any Claude/Codex attribution) to GitHub PR descriptions or commit messages.


- AVOID EM-DASHES LIKE PLAGUE.
