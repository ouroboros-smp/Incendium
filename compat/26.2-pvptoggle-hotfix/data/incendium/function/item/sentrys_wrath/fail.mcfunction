# from: ./on_shot
# @s: player

title @s actionbar ["", {translate:"incendium.item.sentrys_wrath.name",fallback:"Sentry's Wrath", "color": "#33ccff", "bold": true}, " ", {translate:"incendium.system.cooldown",fallback:"is still on cooldown", "color": "#0077bb"}]
playsound minecraft:block.fire.extinguish master @s ~ ~ ~ 1 2

# Cooldown feedback must never detonate the full magic burst on its wielder.
execute anchored eyes positioned ^ ^ ^0.5 run particle minecraft:electric_spark ~ ~ ~ 0.25 0.25 0.25 0.08 24 force
