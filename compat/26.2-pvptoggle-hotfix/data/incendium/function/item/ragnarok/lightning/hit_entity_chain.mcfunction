scoreboard players set #hit in.fire_laser 0
tag @s add laser

function ouroboros_incendium_hotfix:damage/ragnarok
execute at @s run particle minecraft:electric_spark ~ ~1 ~ 0.55 0.9 0.55 0.16 95 force

data modify entity @s[type=creeper] powered set value 1b

execute at @s positioned ~ ~1 ~ if score #hit in.fire_laser matches 0 if predicate incendium:random/87 if score #distance2 in.fire_laser matches 0..3000 positioned ^ ^ ^0.2 facing entity @e[type=#incendium:mobs,tag=!laser,distance=..10,sort=nearest,limit=1] eyes if block ~ ~ ~ #incendium:airs run function incendium:item/ragnarok/lightning/branch_straight
