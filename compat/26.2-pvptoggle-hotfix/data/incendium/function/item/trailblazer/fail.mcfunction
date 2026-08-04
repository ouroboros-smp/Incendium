# from ./shot
# @s: player

tellraw @s [{translate:"incendium.item.trailblazer.name",fallback:"Trailblazer", "color": "#F7823E", "bold": true}, " ", {translate:"incendium.item.trailblazer.system.fail",fallback:"requires a fully drawn back bow to function", "color":"#C46731", "bold": false}]

# A failed draw is feedback, not a point-blank unowned explosion.
execute anchored eyes positioned ^ ^ ^0.25 run particle minecraft:flame ~ ~ ~ 0.3 0.3 0.3 0.08 35 force
execute anchored eyes positioned ^ ^ ^0.25 run particle minecraft:small_flame ~ ~ ~ 0.2 0.2 0.2 0.04 20 force

kill @e[type=#arrows,tag=!in.checked,distance=..3]

playsound minecraft:entity.blaze.shoot master @s ~ ~ ~ 1 2
playsound minecraft:entity.firework_rocket.launch master @s ~ ~ ~ 0.25 1.69
