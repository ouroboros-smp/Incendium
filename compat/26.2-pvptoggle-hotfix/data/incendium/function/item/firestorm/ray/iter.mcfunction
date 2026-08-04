execute if score #hit in.fire_laser matches 0 positioned ~-0.05 ~-0.05 ~-0.05 as @e[type=#incendium:mobs,tag=!laser,dx=0,sort=nearest] if score #distance in.fire_laser matches 10.. positioned ~-0.85 ~-0.85 ~-0.85 if entity @s[dx=0] run function incendium:item/firestorm/ray/hit_chain

scoreboard players add #distance in.fire_laser 1

execute positioned ^ ^ ^0.2 unless block ~ ~ ~ #incendium:airs run particle minecraft:flame ~ ~0.2 ~ 0.4 0.4 0.4 0.08 45 force

execute if predicate incendium:random/50 run particle minecraft:flame ~ ~ ~ 0.01 0.01 0.01 0.001 1 force

scoreboard players set #distance2 in.fire_laser 0
execute if score #hit in.fire_laser matches 0 if predicate incendium:random/5 if score #distance in.fire_laser matches ..35 positioned ^ ^ ^0.2 rotated ~ ~ if block ~ ~ ~ #incendium:airs run function incendium:item/firestorm/ray/branch
execute if score #hit in.fire_laser matches 0 if predicate incendium:random/20 if score #distance in.fire_laser matches 35..120 positioned ^ ^ ^0.2 rotated ~ ~ if block ~ ~ ~ #incendium:airs run function incendium:item/firestorm/ray/branch

execute if score #hit in.fire_laser matches 0 if score #distance in.fire_laser matches ..120 positioned ^ ^ ^0.2 rotated ~ ~ if block ~ ~ ~ #incendium:airs run function incendium:item/firestorm/ray/iter
