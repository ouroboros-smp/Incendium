# @s: entity struck by a Trailblazer arrow

# Depending on the event relation, the indirect attacker is exposed as either
# the player or the owned arrow. Cover both without using a nearest-player guess.
execute on attacker if entity @s[type=player] run tag @s add ouroboros.trailblazer_owner
execute on attacker on origin if entity @s[type=player] run tag @s add ouroboros.trailblazer_owner
execute as @a[tag=ouroboros.trailblazer_owner,team=] run tag @s add ouroboros.trailblazer_active_attacker
execute as @a[tag=ouroboros.trailblazer_owner,team=COMBAT_TEAM] run tag @s add ouroboros.trailblazer_active_attacker

execute if entity @a[tag=ouroboros.trailblazer_owner,limit=1] as @e[type=#incendium:mobs,distance=..4.5,tag=!ouroboros.trailblazer_owner] run function ouroboros_incendium_hotfix:damage/trailblazer_burst

tag @a[tag=ouroboros.trailblazer_owner] remove ouroboros.trailblazer_owner
tag @a[tag=ouroboros.trailblazer_active_attacker] remove ouroboros.trailblazer_active_attacker
