# @s: entity intersected by Trailblazer's fire trail

execute unless entity @s[type=player] run damage @s 5 minecraft:fireball by @a[tag=ouroboros.trailblazer_owner,limit=1]
execute if entity @a[tag=ouroboros.trailblazer_active_attacker,limit=1] if entity @s[type=player,team=] run damage @s 5 minecraft:fireball by @a[tag=ouroboros.trailblazer_owner,limit=1]
execute if entity @a[tag=ouroboros.trailblazer_active_attacker,limit=1] if entity @s[type=player,team=COMBAT_TEAM] run damage @s 5 minecraft:fireball by @a[tag=ouroboros.trailblazer_owner,limit=1]
