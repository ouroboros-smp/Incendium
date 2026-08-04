# @s: Trailblazer arrow

data modify storage ouroboros_incendium_hotfix:temp trailblazer_owner.UUID set from entity @s Owner
function ouroboros_incendium_hotfix:trailblazer/tag_owner with storage ouroboros_incendium_hotfix:temp trailblazer_owner

execute as @e[type=#incendium:mobs,distance=..1.5,tag=!ouroboros.trailblazer_owner] run function ouroboros_incendium_hotfix:damage/trailblazer_trail
execute as @e[type=#incendium:mobs_no_player,distance=..1.5] run data merge entity @s {Fire:80s}
execute if entity @a[tag=ouroboros.trailblazer_active_attacker,limit=1] as @a[distance=..1.5,tag=!ouroboros.trailblazer_owner,team=] run data merge entity @s {Fire:80s}
execute if entity @a[tag=ouroboros.trailblazer_active_attacker,limit=1] as @a[distance=..1.5,tag=!ouroboros.trailblazer_owner,team=COMBAT_TEAM] run data merge entity @s {Fire:80s}

tag @a[tag=ouroboros.trailblazer_owner] remove ouroboros.trailblazer_owner
tag @a[tag=ouroboros.trailblazer_active_attacker] remove ouroboros.trailblazer_active_attacker
