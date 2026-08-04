# from: ./fireball
# @s: owned Holy Wrath fireball

# Fireworks bypass PvP Toggle. Recover the fireball's exact owner and apply an
# attributed equivalent burst only when both player participants allow PvP.
data modify storage ouroboros_incendium_hotfix:temp holy_wrath_owner.UUID set from entity @s Owner
function ouroboros_incendium_hotfix:holy_wrath/tag_owner with storage ouroboros_incendium_hotfix:temp holy_wrath_owner

particle minecraft:end_rod ~ ~ ~ 0.65 0.65 0.65 0.1 70 force
particle minecraft:electric_spark ~ ~ ~ 0.45 0.45 0.45 0.08 35 force

execute as @e[type=#incendium:mobs,distance=..2,tag=!in.sanctum_guardian] run function ouroboros_incendium_hotfix:damage/holy_wrath

execute as @e[type=#incendium:mobs_no_player,distance=..2,tag=!in.sanctum_guardian] run function incendium:item/patron/holy_wrath/kick

tag @a[tag=ouroboros.holy_wrath_owner] remove ouroboros.holy_wrath_owner
tag @a[tag=ouroboros.holy_wrath_active_attacker] remove ouroboros.holy_wrath_active_attacker

kill @s
