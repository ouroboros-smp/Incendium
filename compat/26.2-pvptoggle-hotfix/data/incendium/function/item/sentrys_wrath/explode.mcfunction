# from: ./marker
# @s: marker

# Mark the marker's exact owner so even a point-blank active-PvP shot cannot
# damage its wielder. The marker stores this UUID during Incendium's init.
data modify storage ouroboros_incendium_hotfix:temp sentry_owner set from entity @s data.player
function ouroboros_incendium_hotfix:sentrys_wrath/tag_owner with storage ouroboros_incendium_hotfix:temp sentry_owner

# PvP Toggle exposes opted-out players through PASSIVE_TEAM. Keep the direct
# magic hit for active players, but never target passive players.
effect give @e[type=#incendium:mobs_no_player,type=#minecraft:undead,distance=..4.5] instant_health 1 2
effect give @e[type=#incendium:mobs_no_player,type=!#minecraft:undead,distance=..4.5] instant_damage 1 2
execute as @a[distance=..4.5,tag=!ouroboros.sentry_owner] run function ouroboros_incendium_hotfix:damage/sentrys_wrath

tag @a[tag=ouroboros.sentry_owner] remove ouroboros.sentry_owner
tag @a[tag=ouroboros.sentry_active_attacker] remove ouroboros.sentry_active_attacker

playsound minecraft:block.respawn_anchor.deplete player @a[distance=..40] ~ ~ ~ 1.0 2.0 0.8
playsound minecraft:entity.wither.break_block player @a[distance=..40] ~ ~ ~ 1 0.85 0.7
playsound minecraft:block.respawn_anchor.deplete player @a[distance=..40] ~ ~ ~ 1.0 0.5 0.8

# Fireworks do not route their splash damage through Player#canHarmPlayer, so
# use particles for the visual burst instead of an indiscriminate damage source.
particle minecraft:electric_spark ~ ~0.1 ~ 2.0 2.0 2.0 0.3 120 force

execute as @e[type=#incendium:mobs_no_player,distance=..8] at @s run function incendium:item/sentrys_wrath/kick

kill @s[type=marker]

execute if predicate incendium:random/50 positioned ~ ~0.1 ~ rotated 0 -90 run function incendium:item/sentrys_wrath/short_lightning/start_ray
execute if predicate incendium:random/50 positioned ~ ~0.1 ~ rotated 0 -45 run function incendium:item/sentrys_wrath/short_lightning/start_ray
execute if predicate incendium:random/50 positioned ~ ~0.1 ~ rotated 90 -45 run function incendium:item/sentrys_wrath/short_lightning/start_ray
execute if predicate incendium:random/50 positioned ~ ~0.1 ~ rotated 180 -45 run function incendium:item/sentrys_wrath/short_lightning/start_ray
execute if predicate incendium:random/50 positioned ~ ~0.1 ~ rotated 250 -45 run function incendium:item/sentrys_wrath/short_lightning/start_ray
execute if predicate incendium:random/50 positioned ~ ~0.1 ~ rotated 315 -45 run function incendium:item/sentrys_wrath/short_lightning/start_ray
execute if predicate incendium:random/50 positioned ~ ~0.1 ~ rotated 45 -45 run function incendium:item/sentrys_wrath/short_lightning/start_ray
execute if predicate incendium:random/50 positioned ~ ~0.1 ~ rotated 135 -45 run function incendium:item/sentrys_wrath/short_lightning/start_ray
execute if predicate incendium:random/50 positioned ~ ~0.1 ~ rotated 180 -45 run function incendium:item/sentrys_wrath/short_lightning/start_ray
execute if predicate incendium:random/50 positioned ~ ~0.1 ~ rotated 225 -45 run function incendium:item/sentrys_wrath/short_lightning/start_ray
execute if predicate incendium:random/50 positioned ~ ~0.1 ~ rotated 0 45 run function incendium:item/sentrys_wrath/short_lightning/start_ray
execute if predicate incendium:random/50 positioned ~ ~0.1 ~ rotated 90 45 run function incendium:item/sentrys_wrath/short_lightning/start_ray
execute if predicate incendium:random/50 positioned ~ ~0.1 ~ rotated 180 45 run function incendium:item/sentrys_wrath/short_lightning/start_ray
execute if predicate incendium:random/50 positioned ~ ~0.1 ~ rotated 250 45 run function incendium:item/sentrys_wrath/short_lightning/start_ray
execute if predicate incendium:random/50 positioned ~ ~0.1 ~ rotated 315 45 run function incendium:item/sentrys_wrath/short_lightning/start_ray
execute if predicate incendium:random/50 positioned ~ ~0.1 ~ rotated 45 45 run function incendium:item/sentrys_wrath/short_lightning/start_ray
execute if predicate incendium:random/50 positioned ~ ~0.1 ~ rotated 135 45 run function incendium:item/sentrys_wrath/short_lightning/start_ray
execute if predicate incendium:random/50 positioned ~ ~0.1 ~ rotated 180 45 run function incendium:item/sentrys_wrath/short_lightning/start_ray
execute if predicate incendium:random/50 positioned ~ ~0.1 ~ rotated 225 45 run function incendium:item/sentrys_wrath/short_lightning/start_ray
execute if predicate incendium:random/50 positioned ~ ~0.1 ~ rotated 0 0 run function incendium:item/sentrys_wrath/short_lightning/start_ray
execute if predicate incendium:random/50 positioned ~ ~0.1 ~ rotated 90 0 run function incendium:item/sentrys_wrath/short_lightning/start_ray
execute if predicate incendium:random/50 positioned ~ ~0.1 ~ rotated 180 0 run function incendium:item/sentrys_wrath/short_lightning/start_ray
execute if predicate incendium:random/50 positioned ~ ~0.1 ~ rotated 250 0 run function incendium:item/sentrys_wrath/short_lightning/start_ray
execute if predicate incendium:random/50 positioned ~ ~0.1 ~ rotated 315 0 run function incendium:item/sentrys_wrath/short_lightning/start_ray
execute if predicate incendium:random/50 positioned ~ ~0.1 ~ rotated 45 0 run function incendium:item/sentrys_wrath/short_lightning/start_ray
execute if predicate incendium:random/50 positioned ~ ~0.1 ~ rotated 135 0 run function incendium:item/sentrys_wrath/short_lightning/start_ray
execute if predicate incendium:random/50 positioned ~ ~0.1 ~ rotated 180 0 run function incendium:item/sentrys_wrath/short_lightning/start_ray
execute if predicate incendium:random/50 positioned ~ ~0.1 ~ rotated 225 0 run function incendium:item/sentrys_wrath/short_lightning/start_ray
