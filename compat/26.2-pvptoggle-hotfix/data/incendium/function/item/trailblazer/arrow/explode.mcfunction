# from ./main
# @s: arrow

# End the trail with the original damaging burst, now filtered and attributed
# to the exact bow owner.
function ouroboros_incendium_hotfix:trailblazer/explode
particle minecraft:flame ~ ~ ~ .25 1.25 .25 .1 50 force
particle minecraft:small_flame ~ ~ ~ .25 1.25 .25 .6 50 force
kill @s
