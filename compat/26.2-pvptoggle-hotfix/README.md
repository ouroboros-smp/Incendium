# Incendium 26.2 / PvP Toggle hotfix

This compatibility datapack is for the Ouroboros SMP 26.2 stack:

- Incendium Legacy 5.5.0
- PvP Toggle 1.6.1 or newer
- PvP Toggle's `team_colors` option enabled

It fixes the ranged-weapon integration regressions across Incendium's complete
custom bow/crossbow set:

1. Trailblazer and Ragnarok now accumulate their draw-time score, preventing a
   valid fully drawn shot from entering the misfire path. Their rejected-shot
   and instability feedback is also visual-only, so an undercharged shot never
   damages its wielder.
2. Trailblazer's fire trail, impact, and terminal bursts retain their PvE/AoE
   damage through exact-owner-attributed commands, while passive players and
   the shooter are excluded.
3. Firestorm and Ragnarok ray hits retain the exact shooter as their attributed
   source and damage players only when both participants have PvP enabled. Their
   unattributed fireworks and lightning are replaced with particles.
4. Holy Wrath's cluster fireballs retain their exact owner and replace their
   firework entities with equivalent attributed burst damage. Active players
   remain valid burst targets, while passive players and the shooter are safe.
5. Sentry's Wrath retains and excludes its exact owner, requires both
   participants to have PvP enabled, and replaces its indiscriminate firework
   with particles. PvP-active targets still take the intended magic damage.

Multiplex Crossbow needs no override: its owned arrows and rockets already
honor PvP Toggle. It is included in the headless regression matrix alongside
the five overridden weapons.

Firework splash, unowned fireballs, and summoned lightning do not consistently
consult PvP Toggle's player-vs-player policy. This pack therefore keeps owned
projectiles for player combat and uses explicitly filtered, owner-attributed
damage with the original `fireworks`/magic damage type for custom effects,
while retaining non-damaging particle bursts for the original visuals.

For datapack-only testing, install this directory as a separate world datapack
after Incendium. It is an override-only compatibility addon and does not
contain the Incendium pack.

For the production Legacy mod, assemble the reviewed override files into the
exact upstream 26.2 / 5.5.0 jar with `build-legacy-jar.ps1`. The script accepts
only the base jar with SHA256
`1626bcced55d5baa3a9c7c3526c830880cbd828bd8793a3cfc60f713479fcc34`, copies
only this addon's `data/` tree, stamps Fabric version
`5.5.0+ouroboros.rangedhotfix.1`, verifies every override byte-for-byte, rejects
duplicate entries, and runs `jar --validate`.

```powershell
pwsh ./build-legacy-jar.ps1 `
  -BaseJar "C:\path\to\Incendium_Legacy_26.2_5.5.0.jar" `
  -OutputJar "C:\path\to\Incendium_Legacy_26.2_5.5.0-ouroboros-ranged-hotfix.1.jar"
```

The expected output SHA256 is
`194020e5674afbc46e4ec3d061268e9a003a96fd2675bccd893f1f7809fd0dda`.
Deploy that jar as the only active Incendium jar. Keep the original base jar
outside the active `mods/` directory as the rollback artifact, and keep the
standalone hotfix datapack disabled while the merged jar is active. To roll
back, stop the server, remove the hotfix jar from `mods/`, restore the base jar,
and start the server.

Run the static checks with:

```powershell
node ./test.mjs
```

Run the reproducible real-client matrix against primordial-staging with the
Ouroboros test harness pinned to commit
`ce208c3733979929f26adaedf9e583e64f0dc975`. The bundled patch adds the two
protocol actions needed to draw and release bows/crossbows:

```powershell
$hotfixRoot = (Get-Location).Path
$harnessRepo = "K:\ouroboros-smp\test-harness"
$harnessTask = & "C:\Users\rawnr\.agent-stack\scripts\new-managed-worktree.ps1" `
  -Repository $harnessRepo `
  -Branch "codex/incendium-ranged-hotfix-verification" `
  -StartPoint ce208c3733979929f26adaedf9e583e64f0dc975
$env:OURO_HARNESS_ROOT = $harnessTask.Worktree
git -C $env:OURO_HARNESS_ROOT apply --check --unidiff-zero "$hotfixRoot\test-harness.patch"
git -C $env:OURO_HARNESS_ROOT apply --unidiff-zero "$hotfixRoot\test-harness.patch"
npm --prefix $env:OURO_HARNESS_ROOT ci
npm --prefix $env:OURO_HARNESS_ROOT run build
npm --prefix $env:OURO_HARNESS_ROOT run build:client
$env:OURO_HARNESS_CLIENT = "$env:OURO_HARNESS_ROOT\client\target\debug\ouro-harness-client.exe"
$env:HEADLESS_RELOAD = "1"
node ./headless-matrix.mjs
```

After testing, revert the temporary harness patch and use the managed-worktree
cleanup report before removing the eligible test worktree:

```powershell
git -C $env:OURO_HARNESS_ROOT apply -R --unidiff-zero "$hotfixRoot\test-harness.patch"
pwsh -NoProfile -File "C:\Users\rawnr\.agent-stack\scripts\cleanup-managed-worktrees.ps1" `
  -Repository $harnessRepo
pwsh -NoProfile -File "C:\Users\rawnr\.agent-stack\scripts\cleanup-managed-worktrees.ps1" `
  -Repository $harnessRepo -Execute -DeleteMergedBranches
```

`HEADLESS_FILTER` accepts a regular expression for a focused rerun, such as
`$env:HEADLESS_FILTER = "ragnarok|sentry"`. The runner verifies the scoreboard
team before toggling either client, cleans its temporary arena after every case,
and fails on shooter damage, damage involving a passive participant, or missing
active-PvP control damage.

The primordial-staging headless acceptance matrix verifies:

- zero shooter damage for fully drawn and rejected Trailblazer/Ragnarok shots;
- zero damage to `PASSIVE_TEAM` targets for all six custom weapons (including
  both arrow and rocket ammunition for Multiplex Crossbow); and
- zero player damage when the shooter has PvP disabled;
- non-zero damage to PvP-active targets for every weapon/ammunition path; and
- Sentry's Wrath cooldown and point-blank owner-exclusion behavior.
