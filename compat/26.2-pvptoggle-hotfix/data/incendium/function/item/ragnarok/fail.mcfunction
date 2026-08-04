# from ./shot
# @s: player

tellraw @s [{translate:"incendium.item.ragnarok.name",fallback:"Ragnarok", "color": "#CCEBDB", "bold": true}, " ", {translate:"incendium.item.ragnarok.system.fail",fallback:"cannot be rapid fired", "color":"#ABC4B8", "bold": false}]

# A rejected shot keeps its feedback without striking its wielder.
particle minecraft:electric_spark ~ ~1 ~ 0.45 0.8 0.45 0.15 80 force
particle minecraft:end_rod ~ ~1 ~ 0.25 0.5 0.25 0.08 35 force

playsound minecraft:item.trident.thunder player @a[distance=..16] ~ ~ ~ 2 2
playsound minecraft:item.trident.thunder player @a[distance=..16] ~ ~ ~ 2 .1
