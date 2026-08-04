$tag @a[nbt={UUID:$(UUID)}] add ouroboros.sentry_owner
$execute as @a[nbt={UUID:$(UUID)},team=] run tag @s add ouroboros.sentry_active_attacker
$execute as @a[nbt={UUID:$(UUID)},team=COMBAT_TEAM] run tag @s add ouroboros.sentry_active_attacker
