scoreboard players set #hit in.fire_laser 0
tag @s add laser

function ouroboros_incendium_hotfix:damage/ragnarok
execute at @s run particle minecraft:electric_spark ~ ~1 ~ 0.55 0.9 0.55 0.16 95 force

data modify entity @s[type=creeper] powered set value 1b
