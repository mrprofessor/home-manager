# Orca command reference

## Preflight

```sh
orca doctor
```

Run inside Herdr. `doctor` must report the server, `jq`, Claude, Codex, and the
current workspace as available.

## Spawn

```sh
RUN=$(orca spawn \
  --label api-review \
  --agent codex \
  --place tab \
  --cwd "$PWD" \
  --prompt "Read-only: review the API boundary for correctness and cite files." \
  | jq -r .run)

orca spawn \
  --run "$RUN" \
  --label implementation \
  --agent claude \
  --place worktree \
  --cwd "$PWD" \
  --trust \
  --prompt "Implement the agreed change in isolation. Run focused tests, commit the result, and report the commit hash."
```

Agents are persistent interactive chats and default to yolo permissions.
`--trust` accepts only the known first-run folder-trust UI. Pass `--safe` when
normal Claude permissions or Codex's workspace sandbox should be retained.

## Observe and coordinate

```sh
orca status --run "$RUN"
orca peek --run "$RUN" --name api-review --lines 80
orca stream --run "$RUN" --name api-review
orca send --run "$RUN" --name api-review --text $'Check the caller at src/server.ts too.\n'
orca focus --run "$RUN" --name api-review
```

`stream` emits raw Herdr `terminal.frame` NDJSON. Use `peek` for ordinary text
inspection. Include a newline in `send` when the TUI should submit the message.
`focus` switches the attached Herdr client to the worker's persistent chat.

## Wait and collect

```sh
orca await --run "$RUN" --timeout 900
orca collect --run "$RUN"
```

`await` exits `0` when the mailbox contract is complete, `2` when a worker is
blocked, and `124` on timeout. A mailbox completes the assigned turn while the
chat remains open.

## Cleanup

```sh
orca cleanup --run "$RUN"
```

Cleanup closes only owned `tab` placements after checking their run tag. It does
not remove worktrees or workspaces. Use it only when persistent chats are no
longer useful.
