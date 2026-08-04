# from: player/event/on_hit/entity
# @s: entity hit by arrow

# Preserve the impact burst with exact-attacker attribution and PvP filtering.
function ouroboros_incendium_hotfix:trailblazer/on_hit
execute anchored eyes positioned ~ ~0.25 ~ run particle minecraft:flame ~ ~ ~ 0.35 0.6 0.35 0.08 45 force
execute anchored eyes positioned ~ ~0.25 ~ run particle minecraft:small_flame ~ ~ ~ 0.25 0.4 0.25 0.04 25 force
