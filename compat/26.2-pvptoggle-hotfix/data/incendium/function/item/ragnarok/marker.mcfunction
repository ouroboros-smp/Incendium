# from: ./shot
# @s: Ragnarok marker

scoreboard players operation @s in.ragnarok = $ragnarok in.dummy

tp @s ~ ~ ~ ~ ~

data modify entity @s Rotation set from storage incendium:temp player.Rotation

# The marker is created while the shooter still carries in.self, so preserve
# the exact owner UUID for scheduled rays on later ticks.
data modify entity @s data.player.UUID set from entity @p[tag=in.self,distance=..5] UUID

tag @s add in.checked

playsound minecraft:entity.lightning_bolt.thunder player @a[distance=..16] ~ ~ ~ 2 2
