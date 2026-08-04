# from: ./loop
# @s: Ragnarok marker

# Scheduled rays run after Incendium removes in.self from the shooter. Recover
# the stored UUID and tag that exact player so every branch's tag=!laser filter
# excludes the wielder.
data modify storage ouroboros_incendium_hotfix:temp ragnarok_owner set from entity @s data.player
function ouroboros_incendium_hotfix:ragnarok/tag_owner with storage ouroboros_incendium_hotfix:temp ragnarok_owner

scoreboard players operation $ragnarok in.dummy = @s in.ragnarok
scoreboard players operation $random in.dummy = $ragnarok in.dummy
scoreboard players remove $random in.dummy 20

execute if score $ragnarok in.dummy matches 5.. run function incendium:item/ragnarok/lightning/start_ray

execute if score $ragnarok in.dummy matches 100.. if predicate incendium:random/other/x if predicate incendium:random/50 rotated ~10 ~5 run function incendium:item/ragnarok/lightning/start_ray
execute if score $ragnarok in.dummy matches 100.. if predicate incendium:random/other/x if predicate incendium:random/50 rotated ~-10 ~5 run function incendium:item/ragnarok/lightning/start_ray

tag @a remove laser
tag @a remove ouroboros.ragnarok_owner
tag @a remove ouroboros.ragnarok_active_attacker

kill @s
