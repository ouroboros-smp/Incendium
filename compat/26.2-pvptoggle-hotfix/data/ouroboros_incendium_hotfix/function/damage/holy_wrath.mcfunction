# @s: entity inside a Holy Wrath fireball burst

execute unless entity @s[type=player] run damage @s 14 minecraft:fireworks by @a[tag=ouroboros.holy_wrath_owner,limit=1]
execute unless entity @s[tag=ouroboros.holy_wrath_owner] if entity @a[tag=ouroboros.holy_wrath_active_attacker,limit=1] if entity @s[type=player,team=] run damage @s 14 minecraft:fireworks by @a[tag=ouroboros.holy_wrath_owner,limit=1]
execute unless entity @s[tag=ouroboros.holy_wrath_owner] if entity @a[tag=ouroboros.holy_wrath_active_attacker,limit=1] if entity @s[type=player,team=COMBAT_TEAM] run damage @s 14 minecraft:fireworks by @a[tag=ouroboros.holy_wrath_owner,limit=1]
