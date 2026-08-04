# @s: entity intersected by a Ragnarok ray

execute unless entity @s[type=player] run damage @s 18 minecraft:fireworks by @a[tag=ouroboros.ragnarok_owner,limit=1]
execute if entity @a[tag=ouroboros.ragnarok_active_attacker,limit=1] if entity @s[type=player,team=] run damage @s 18 minecraft:fireworks by @a[tag=ouroboros.ragnarok_owner,limit=1]
execute if entity @a[tag=ouroboros.ragnarok_active_attacker,limit=1] if entity @s[type=player,team=COMBAT_TEAM] run damage @s 18 minecraft:fireworks by @a[tag=ouroboros.ragnarok_owner,limit=1]
