$tag @a[nbt={UUID:$(UUID)}] add ouroboros.trailblazer_owner
$execute as @a[nbt={UUID:$(UUID)},team=] run tag @s add ouroboros.trailblazer_active_attacker
$execute as @a[nbt={UUID:$(UUID)},team=COMBAT_TEAM] run tag @s add ouroboros.trailblazer_active_attacker
