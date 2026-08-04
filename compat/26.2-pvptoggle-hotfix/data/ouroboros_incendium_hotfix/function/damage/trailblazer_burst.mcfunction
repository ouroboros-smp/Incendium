# @s: entity inside a Trailblazer impact or terminal burst

execute unless entity @s[type=player] run damage @s 14 minecraft:fireworks by @a[tag=ouroboros.trailblazer_owner,limit=1]
execute if entity @a[tag=ouroboros.trailblazer_active_attacker,limit=1] if entity @s[type=player,team=] run damage @s 14 minecraft:fireworks by @a[tag=ouroboros.trailblazer_owner,limit=1]
execute if entity @a[tag=ouroboros.trailblazer_active_attacker,limit=1] if entity @s[type=player,team=COMBAT_TEAM] run damage @s 14 minecraft:fireworks by @a[tag=ouroboros.trailblazer_owner,limit=1]
