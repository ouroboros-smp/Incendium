# @s: Trailblazer arrow at its terminal burst

data modify storage ouroboros_incendium_hotfix:temp trailblazer_owner.UUID set from entity @s Owner
function ouroboros_incendium_hotfix:trailblazer/tag_owner with storage ouroboros_incendium_hotfix:temp trailblazer_owner
execute as @e[type=#incendium:mobs,distance=..4.5,tag=!ouroboros.trailblazer_owner] run function ouroboros_incendium_hotfix:damage/trailblazer_burst
tag @a[tag=ouroboros.trailblazer_owner] remove ouroboros.trailblazer_owner
tag @a[tag=ouroboros.trailblazer_active_attacker] remove ouroboros.trailblazer_active_attacker
