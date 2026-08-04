execute if score #hit in.fire_laser matches 0 positioned ~-0.05 ~-0.05 ~-0.05 as @e[type=#incendium:mobs,tag=!laser,dx=0,sort=nearest] if score #hit in.fire_laser matches 0 if score #distance in.fire_laser matches 10.. positioned ~-0.85 ~-0.85 ~-0.85 if entity @s[dx=0] run function incendium:item/ragnarok/lightning/hit_entity_chain

scoreboard players add #distance in.fire_laser 1

execute positioned ^ ^ ^0.2 unless block ~ ~ ~ #incendium:airs run particle minecraft:electric_spark ~ ~1 ~ 0.45 0.7 0.45 0.14 70 force

execute positioned ^ ^ ^0.2 unless block ~ ~ ~ #incendium:airs if predicate incendium:random/other/x if predicate incendium:random/50 run particle minecraft:end_rod ~ ~ ~ 0.2 0.4 0.2 0.04 20 force

execute if predicate incendium:random/70 run particle minecraft:end_rod ~ ~ ~ 0.01 0.01 0.01 0.0 1 force

execute if score #hit in.fire_laser matches 0 if predicate incendium:random/10 if score #distance in.fire_laser matches ..50 positioned ^ ^ ^0.2 rotated ~ ~ if block ~ ~ ~ #incendium:airs run function incendium:item/ragnarok/lightning/branch

execute if score #hit in.fire_laser matches 0 if predicate incendium:random/25 if score #distance in.fire_laser matches 50.. if score #distance in.fire_laser <= $max_distance in.dummy positioned ^ ^ ^0.2 rotated ~ ~ if block ~ ~ ~ #incendium:airs run function incendium:item/ragnarok/lightning/branch

execute if score #hit in.fire_laser matches 0 if score #distance in.fire_laser <= $max_distance in.dummy positioned ^ ^ ^0.2 rotated ~ ~ if block ~ ~ ~ #incendium:airs run function incendium:item/ragnarok/lightning/ray

execute if score #hit in.fire_laser matches 0 if score #distance in.fire_laser > $max_distance in.dummy positioned ^ ^ ^0.2 if predicate incendium:random/other/x if predicate incendium:random/0_01 run particle minecraft:electric_spark ~ ~ ~ 0.2 0.2 0.2 0.08 18 force
