scoreboard players set #hit in.fire_laser 0
tag @s add laser

function ouroboros_incendium_hotfix:damage/firestorm
particle minecraft:flame ~ ~1 ~ 0.45 0.75 0.45 0.08 45 force

execute at @s positioned ~ ~1 ~ if score #hit in.fire_laser matches 0 if predicate incendium:random/87 if score #distance2 in.fire_laser matches 0..1200 positioned ^ ^ ^0.2 facing entity @e[type=#incendium:mobs,tag=!laser,distance=..10,sort=nearest,limit=1] eyes if block ~ ~ ~ #incendium:airs run function incendium:item/firestorm/ray/iter

execute unless entity @s[type=player] if predicate incendium:random/50 run data merge entity @s {Fire:80s}
execute if entity @a[tag=ouroboros.firestorm_active_attacker,limit=1] if entity @s[type=player,team=] if predicate incendium:random/50 run data merge entity @s {Fire:80s}
execute if entity @a[tag=ouroboros.firestorm_active_attacker,limit=1] if entity @s[type=player,team=COMBAT_TEAM] if predicate incendium:random/50 run data merge entity @s {Fire:80s}
