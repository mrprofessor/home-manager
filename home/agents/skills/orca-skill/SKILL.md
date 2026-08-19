---
name: orca-skill
description: Orchestrate persistent Claude and Codex peer agents in visible Herdr tabs through the orca CLI. Use by default for non-trivial repository tasks inside Herdr that benefit from delegation, parallel investigation, implementation, testing, review, or independent validation, and whenever the user asks for multiple agents, fan-out, peer review, or cross-agent coordination. Do not use outside Herdr or recursively from an orca worker unless nested delegation is explicitly requested.
---

# Orca Orchestration

Keep the primary agent in its current Herdr tab as coordinator. Use `orca` for
worker lifecycle and Herdr placement; do not reimplement spawning with raw
`herdr` commands.

## Establish role

- Act as coordinator only from the user's primary tab.
- If the prompt contains orca's mailbox contract or identifies this agent as an
  orca worker, complete that bounded assignment and write the mailbox. Do not
  invoke orca again unless the assignment explicitly authorizes nested delegation.
- Require `HERDR_ENV=1`. Run `orca doctor` once before the first fleet operation.
- For a non-trivial task, normally delegate at least one independent scope.
  Skip fan-out only when the work is trivial, inherently serial, or cheaper to
  complete directly than to specify and verify.

## Design the fleet

Split work by independent outcome, not arbitrary file counts. Give every worker:

- a unique shell-safe label;
- an exact objective and bounded file or subsystem scope;
- whether it may edit or must remain read-only;
- required checks and evidence;
- instructions to avoid unrelated changes.

Choose placement deliberately:

- `tab`: read-only research, review, or genuinely non-conflicting work in the
  current checkout;
- `worktree`: any parallel edit that could conflict with the coordinator or
  another worker;
- `workspace`: work in a different repository.

For editing worktrees, ask the worker to commit its changes and report the commit
hash. The coordinator owns inspection, integration, conflict resolution, and
final verification. Prefer heterogeneous Claude/Codex review when independent
judgment matters.

## Run the fleet

Read [references/commands.md](references/commands.md) before the first run in a
session or whenever flags are uncertain.

1. Spawn the first worker and capture its run ID from stdout.
2. Add every peer with `--run "$RUN"`.
3. Use `--trust` for a fresh path that the user has intentionally asked agents
   to operate in. Real workers receive yolo permissions by default; pass
   `--safe` only when the user requests normal permission or sandbox controls.
4. Keep stdout machine-readable. Do not parse progress text from stderr.
5. Wait with `orca await`; do not busy-poll Herdr.
6. On exit `2`, inspect the blocked worker with `orca peek`. Send input only
   when the answer is clearly authorized; otherwise ask the user. Use
   `orca focus` when the user should inspect or control that chat directly.
7. Collect every mailbox, inspect worker changes, integrate selected work, and
   run the coordinator's own verification.

Orca injects the mailbox path and completion contract. Do not duplicate or
invent mailbox instructions in worker prompts.

## Preserve chats

Mailbox completion ends the assigned turn, not the chat. Worker tabs remain
interactive so the coordinator or user can inspect transcripts and send
follow-ups with `orca send`.

When the user asks to see, inspect, or take over a worker, run `orca focus` for
that worker. Do not make the user hunt through tab numbers manually.

Do not run `orca cleanup` automatically. Leave useful chats open for user review
unless the user requests cleanup or the tabs are clearly disposable. Orca also
leaves worktree and workspace placements intact; report them explicitly.

## Synthesize

Treat worker output as evidence, not truth. Resolve disagreements, verify claims
against the repository, and present one coherent result. State which work was
integrated, which checks passed, and which persistent tabs or worktrees remain.
