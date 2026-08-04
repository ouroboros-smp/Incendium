# from: ./on_shot
# @s: Firestorm arrow

# Preserve both the exact source and its PvP state for the synchronous ray.
execute on origin if entity @s[tag=in.self,distance=..5] run tag @s add laser
execute on origin if entity @s[tag=in.self,distance=..5] run tag @s add ouroboros.firestorm_owner
execute on origin if entity @s[tag=in.self,distance=..5,team=] run tag @s add ouroboros.firestorm_active_attacker
execute on origin if entity @s[tag=in.self,distance=..5,team=COMBAT_TEAM] run tag @s add ouroboros.firestorm_active_attacker
execute on origin run tag @s remove in.self

function incendium:item/firestorm/ray/start

tag @a remove laser
tag @a remove ouroboros.firestorm_owner
tag @a remove ouroboros.firestorm_active_attacker

kill @s
