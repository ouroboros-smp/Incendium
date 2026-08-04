# @s: player inside Sentry's Wrath burst

execute if entity @a[tag=ouroboros.sentry_active_attacker,limit=1] if entity @s[team=] run damage @s 24 minecraft:magic by @a[tag=ouroboros.sentry_owner,limit=1]
execute if entity @a[tag=ouroboros.sentry_active_attacker,limit=1] if entity @s[team=COMBAT_TEAM] run damage @s 24 minecraft:magic by @a[tag=ouroboros.sentry_owner,limit=1]
