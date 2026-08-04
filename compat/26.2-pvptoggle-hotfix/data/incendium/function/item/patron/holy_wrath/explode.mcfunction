# from: ./arrow

tag @s add in.exploding

execute rotated 0 -22.5 positioned ^ ^ ^2 run function incendium:item/patron/holy_wrath/bomb
execute rotated 90 -22.5 positioned ^ ^ ^2 run function incendium:item/patron/holy_wrath/bomb
execute rotated 180 -22.5 positioned ^ ^ ^2 run function incendium:item/patron/holy_wrath/bomb
execute rotated 270 -22.5 positioned ^ ^ ^2 run function incendium:item/patron/holy_wrath/bomb
execute rotated 315 -22.5 positioned ^ ^ ^2 run function incendium:item/patron/holy_wrath/bomb
execute rotated 45.0 -22.5 positioned ^ ^ ^2 run function incendium:item/patron/holy_wrath/bomb
execute rotated 135 -22.5 positioned ^ ^ ^2 run function incendium:item/patron/holy_wrath/bomb
execute rotated 225 -22.5 positioned ^ ^ ^2 run function incendium:item/patron/holy_wrath/bomb
execute rotated 0 22.5 positioned ^ ^ ^2 run function incendium:item/patron/holy_wrath/bomb
execute rotated 90 22.5 positioned ^ ^ ^2 run function incendium:item/patron/holy_wrath/bomb
execute rotated 180 22.5 positioned ^ ^ ^2 run function incendium:item/patron/holy_wrath/bomb
execute rotated 270 22.5 positioned ^ ^ ^2 run function incendium:item/patron/holy_wrath/bomb
execute rotated 315 22.5 positioned ^ ^ ^2 run function incendium:item/patron/holy_wrath/bomb
execute rotated 45.0 22.5 positioned ^ ^ ^2 run function incendium:item/patron/holy_wrath/bomb
execute rotated 135 22.5 positioned ^ ^ ^2 run function incendium:item/patron/holy_wrath/bomb
execute rotated 225 22.5 positioned ^ ^ ^2 run function incendium:item/patron/holy_wrath/bomb
execute rotated 22.5 0 positioned ^ ^ ^2 run function incendium:item/patron/holy_wrath/bomb
execute rotated 112.5 0 positioned ^ ^ ^2 run function incendium:item/patron/holy_wrath/bomb
execute rotated 202.5 0 positioned ^ ^ ^2 run function incendium:item/patron/holy_wrath/bomb
execute rotated 292.5 0 positioned ^ ^ ^2 run function incendium:item/patron/holy_wrath/bomb
execute rotated 337.5 0 positioned ^ ^ ^2 run function incendium:item/patron/holy_wrath/bomb
execute rotated 67.5 0 positioned ^ ^ ^2 run function incendium:item/patron/holy_wrath/bomb
execute rotated 157.5 0 positioned ^ ^ ^2 run function incendium:item/patron/holy_wrath/bomb
execute rotated 247.5 0 positioned ^ ^ ^2 run function incendium:item/patron/holy_wrath/bomb
execute rotated 22.5 -45 positioned ^ ^ ^2 run function incendium:item/patron/holy_wrath/bomb
execute rotated 112.5 -45 positioned ^ ^ ^2 run function incendium:item/patron/holy_wrath/bomb
execute rotated 202.5 -45 positioned ^ ^ ^2 run function incendium:item/patron/holy_wrath/bomb
execute rotated 292.5 -45 positioned ^ ^ ^2 run function incendium:item/patron/holy_wrath/bomb
execute rotated 337.5 -45 positioned ^ ^ ^2 run function incendium:item/patron/holy_wrath/bomb
execute rotated 67.5 -45 positioned ^ ^ ^2 run function incendium:item/patron/holy_wrath/bomb
execute rotated 157.5 -45 positioned ^ ^ ^2 run function incendium:item/patron/holy_wrath/bomb
execute rotated 247.5 -45 positioned ^ ^ ^2 run function incendium:item/patron/holy_wrath/bomb

# Preserve the starburst without an unowned final firework explosion.
particle minecraft:end_rod ~ ~0.1 ~ 0.9 0.9 0.9 0.12 120 force

execute as @e[type=#incendium:mobs_no_player,distance=..8,tag=!in.sanctum_guardian] at @s facing entity @e[type=#arrows,tag=in.exploding,limit=1,distance=..8] feet run function incendium:item/patron/holy_wrath/kick

kill @s
