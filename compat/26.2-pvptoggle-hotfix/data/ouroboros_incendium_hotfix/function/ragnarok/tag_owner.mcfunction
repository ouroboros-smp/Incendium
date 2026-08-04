$tag @a[nbt={UUID:$(UUID)}] add laser
$tag @a[nbt={UUID:$(UUID)}] add ouroboros.ragnarok_owner
$execute as @a[nbt={UUID:$(UUID)},team=] run tag @s add ouroboros.ragnarok_active_attacker
$execute as @a[nbt={UUID:$(UUID)},team=COMBAT_TEAM] run tag @s add ouroboros.ragnarok_active_attacker
