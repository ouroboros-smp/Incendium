# from ./using
# @s: player holding Ragnarok too long

scoreboard players operation $random in.dummy = @s in.ragnarok
scoreboard players operation $random in.dummy -= #250 in.constants
execute if predicate incendium:weather/thunder run scoreboard players operation $random in.dummy *= #2 in.constants

scoreboard players operation $random in.dummy < #75 in.constants

# Instability is telegraphed visually; it never creates an unowned bolt on the wielder.
execute if predicate incendium:random/other/x if predicate incendium:random/other/x if predicate incendium:random/10 run particle minecraft:electric_spark ~ ~1 ~ 0.35 0.7 0.35 0.12 45 force

title @s[predicate=!incendium:weather/thunder] actionbar [{translate:"incendium.item.ragnarok.name",fallback:"Ragnarok", "color": "#CCEBDB", "bold": true}, " ", {translate:"incendium.item.ragnarok.system.unstable",fallback:"is becoming unstable the longer you hold it's power within", "color":"#ABC4B8", "bold": false}]

title @s[predicate=incendium:weather/thunder] actionbar [{translate:"incendium.item.ragnarok.name",fallback:"Ragnarok", "color": "#CCEBDB", "bold": true}, " ", {translate:"incendium.item.ragnarok.system.storm",fallback:"is becoming more unstable during the storm", "color":"#ABC4B8", "bold": false}]
