execute if score #hit in.fire_laser matches 0 positioned ~-0.05 ~-0.05 ~-0.05 as @e[type=#incendium:mobs_no_player,tag=!laser,dx=0,sort=nearest] if score #distance in.fire_laser matches 10.. positioned ~-0.85 ~-0.85 ~-0.85 if entity @s[dx=0] run function incendium:item/sentrys_wrath/short_lightning/hit_entity_chain
scoreboard players add #distance in.fire_laser 1

execute if predicate incendium:random/50 run particle minecraft:soul_fire_flame ~ ~ ~ 0.01 0.01 0.01 0.0 1 force
execute if score #hit in.fire_laser matches 0 if predicate incendium:random/20 if score #distance in.fire_laser matches ..40 positioned ^ ^ ^0.2 rotated ~ ~ if block ~ ~ ~ #incendium:airs run function incendium:item/sentrys_wrath/short_lightning/branch
execute if score #hit in.fire_laser matches 0 if score #distance in.fire_laser matches ..40 positioned ^ ^ ^0.2 rotated ~ ~ run function incendium:item/sentrys_wrath/short_lightning/ray
