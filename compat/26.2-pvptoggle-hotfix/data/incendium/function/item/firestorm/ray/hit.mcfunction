scoreboard players set #hit in.fire_laser 0
tag @s add laser

function ouroboros_incendium_hotfix:damage/firestorm
particle minecraft:flame ~ ~1 ~ 0.45 0.75 0.45 0.08 55 force

execute unless entity @s[type=player] if predicate incendium:random/50 run data merge entity @s[nbt={Fire:-20s}] {Fire:80s}
execute if entity @a[tag=ouroboros.firestorm_active_attacker,limit=1] if entity @s[type=player,team=] if predicate incendium:random/50 run data merge entity @s[nbt={Fire:-20s}] {Fire:80s}
execute if entity @a[tag=ouroboros.firestorm_active_attacker,limit=1] if entity @s[type=player,team=COMBAT_TEAM] if predicate incendium:random/50 run data merge entity @s[nbt={Fire:-20s}] {Fire:80s}
