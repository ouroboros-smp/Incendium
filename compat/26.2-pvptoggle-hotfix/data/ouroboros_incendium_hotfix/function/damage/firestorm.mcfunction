# @s: entity intersected by a Firestorm ray

execute unless entity @s[type=player] run damage @s 12 minecraft:fireworks by @a[tag=ouroboros.firestorm_owner,limit=1]
execute if entity @a[tag=ouroboros.firestorm_active_attacker,limit=1] if entity @s[type=player,team=] run damage @s 12 minecraft:fireworks by @a[tag=ouroboros.firestorm_owner,limit=1]
execute if entity @a[tag=ouroboros.firestorm_active_attacker,limit=1] if entity @s[type=player,team=COMBAT_TEAM] run damage @s 12 minecraft:fireworks by @a[tag=ouroboros.firestorm_owner,limit=1]
