import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";

const read = (path) => readFile(new URL(path, import.meta.url), "utf8");

const assertNoIndiscriminateDamage = (source, name) => {
  assert.doesNotMatch(source, /summon (?:minecraft:)?firework_rocket/, `${name} must not summon damaging fireworks`);
  assert.doesNotMatch(source, /summon (?:minecraft:)?lightning_bolt/, `${name} must not summon damaging lightning`);
};

const pack = JSON.parse(await read("./pack.mcmeta"));
assert.deepEqual(pack.pack.min_format, [107, 1]);
assert.deepEqual(pack.pack.max_format, [107, 1]);

for (const weapon of ["trailblazer", "ragnarok"]) {
  const advancement = JSON.parse(
    await read(`./data/incendium/advancement/technical/using/${weapon}.json`),
  );
  const item = advancement.criteria.requirement.conditions.item;
  assert.equal(advancement.criteria.requirement.trigger, "minecraft:using_item");
  assert.equal(item.items, undefined, `${weapon} must not use the incompatible items list`);
  assert.match(item.predicates["minecraft:custom_data"], new RegExp(`item:'${weapon}'`));
}

const explosion = await read(
  "./data/incendium/function/item/sentrys_wrath/explode.mcfunction",
);
assert.doesNotMatch(explosion, /effect give .*type=#incendium:mobs,/);
assert.doesNotMatch(explosion, /summon minecraft:firework_rocket/);
assert.match(explosion, /as @a\[distance=\.\.4\.5,tag=!ouroboros\.sentry_owner\] run function ouroboros_incendium_hotfix:damage\/sentrys_wrath/);
assert.match(explosion, /function ouroboros_incendium_hotfix:sentrys_wrath\/tag_owner with storage/);
assert.match(explosion, /tag=!ouroboros\.sentry_owner/);
assert.match(explosion, /tag @a\[tag=ouroboros\.sentry_owner\] remove ouroboros\.sentry_owner/);
assert.match(explosion, /tag @a\[tag=ouroboros\.sentry_active_attacker\] remove ouroboros\.sentry_active_attacker/);

const sentryDamage = await read(
  "./data/ouroboros_incendium_hotfix/function/damage/sentrys_wrath.mcfunction",
);
assert.match(sentryDamage, /tag=ouroboros\.sentry_active_attacker/);
assert.match(sentryDamage, /@s\[team=\]/);
assert.match(sentryDamage, /@s\[team=COMBAT_TEAM\]/);
assert.match(sentryDamage, /by @a\[tag=ouroboros\.sentry_owner,limit=1\]/);
assert.doesNotMatch(sentryDamage, /PASSIVE_TEAM/);

const sentryFail = await read(
  "./data/incendium/function/item/sentrys_wrath/fail.mcfunction",
);
assert.doesNotMatch(sentryFail, /function incendium:item\/sentrys_wrath\/explode/);
assertNoIndiscriminateDamage(sentryFail, "Sentry's Wrath cooldown failure");

const sentryOwnerMacro = await read(
  "./data/ouroboros_incendium_hotfix/function/sentrys_wrath/tag_owner.mcfunction",
);
assert.match(sentryOwnerMacro, /^\$tag @a\[nbt=\{UUID:\$\(UUID\)\}\] add ouroboros\.sentry_owner/m);
assert.match(sentryOwnerMacro, /team=\] run tag @s add ouroboros\.sentry_active_attacker/);
assert.match(sentryOwnerMacro, /team=COMBAT_TEAM\] run tag @s add ouroboros\.sentry_active_attacker/);

const lightningRay = await read(
  "./data/incendium/function/item/sentrys_wrath/short_lightning/ray.mcfunction",
);
assert.match(lightningRay, /type=#incendium:mobs_no_player/);
assert.doesNotMatch(lightningRay, /type=#incendium:mobs,/);

for (const path of [
  "./data/incendium/function/item/trailblazer/fail.mcfunction",
  "./data/incendium/function/item/trailblazer/on_hit.mcfunction",
  "./data/incendium/function/item/trailblazer/arrow/explode.mcfunction",
  "./data/incendium/function/item/trailblazer/arrow/main.mcfunction",
]) {
  const source = await read(path);
  assertNoIndiscriminateDamage(source, path);
  assert.doesNotMatch(source, /summon (?:minecraft:)?small_fireball/, `${path} must not summon unowned fireballs`);
}

const trailblazerMain = await read(
  "./data/incendium/function/item/trailblazer/arrow/main.mcfunction",
);
assert.match(trailblazerMain, /function ouroboros_incendium_hotfix:trailblazer\/trail/);
const trailblazerExplode = await read(
  "./data/incendium/function/item/trailblazer/arrow/explode.mcfunction",
);
assert.match(trailblazerExplode, /function ouroboros_incendium_hotfix:trailblazer\/explode/);
const trailblazerOnHit = await read(
  "./data/incendium/function/item/trailblazer/on_hit.mcfunction",
);
assert.match(trailblazerOnHit, /function ouroboros_incendium_hotfix:trailblazer\/on_hit/);

for (const effect of ["trail", "burst"]) {
  const damage = await read(
    `./data/ouroboros_incendium_hotfix/function/damage/trailblazer_${effect}.mcfunction`,
  );
  assert.match(damage, /unless entity @s\[type=player\] run damage @s/);
  assert.match(damage, /tag=ouroboros\.trailblazer_active_attacker/);
  assert.match(damage, /@s\[type=player,team=\]/);
  assert.match(damage, /@s\[type=player,team=COMBAT_TEAM\]/);
  assert.match(damage, /by @a\[tag=ouroboros\.trailblazer_owner,limit=1\]/);
}

const trailblazerOwnerMacro = await read(
  "./data/ouroboros_incendium_hotfix/function/trailblazer/tag_owner.mcfunction",
);
assert.match(trailblazerOwnerMacro, /^\$tag @a\[nbt=\{UUID:\$\(UUID\)\}\] add ouroboros\.trailblazer_owner/m);
assert.match(trailblazerOwnerMacro, /team=\] run tag @s add ouroboros\.trailblazer_active_attacker/);
assert.match(trailblazerOwnerMacro, /team=COMBAT_TEAM\] run tag @s add ouroboros\.trailblazer_active_attacker/);

for (const path of [
  "./data/incendium/function/item/ragnarok/fail.mcfunction",
  "./data/incendium/function/item/ragnarok/unstable.mcfunction",
  "./data/incendium/function/item/ragnarok/lightning/ray.mcfunction",
  "./data/incendium/function/item/ragnarok/lightning/branch.mcfunction",
  "./data/incendium/function/item/ragnarok/lightning/branch_straight.mcfunction",
  "./data/incendium/function/item/ragnarok/lightning/hit_entity.mcfunction",
  "./data/incendium/function/item/ragnarok/lightning/hit_entity_chain.mcfunction",
]) {
  assertNoIndiscriminateDamage(await read(path), path);
}

const ragnarokMarker = await read(
  "./data/incendium/function/item/ragnarok/marker.mcfunction",
);
assert.match(ragnarokMarker, /data\.player\.UUID set from entity @p\[tag=in\.self,distance=\.\.5\] UUID/);

const ragnarokRay = await read(
  "./data/incendium/function/item/ragnarok/ray.mcfunction",
);
assert.match(ragnarokRay, /function ouroboros_incendium_hotfix:ragnarok\/tag_owner with storage/);
assert.match(ragnarokRay, /tag @a remove laser/);

const ragnarokOwnerMacro = await read(
  "./data/ouroboros_incendium_hotfix/function/ragnarok/tag_owner.mcfunction",
);
assert.match(ragnarokOwnerMacro, /^\$tag @a\[nbt=\{UUID:\$\(UUID\)\}\] add laser/m);
assert.match(ragnarokOwnerMacro, /add ouroboros\.ragnarok_owner/);
assert.match(ragnarokOwnerMacro, /team=\] run tag @s add ouroboros\.ragnarok_active_attacker/);
assert.match(ragnarokOwnerMacro, /team=COMBAT_TEAM\] run tag @s add ouroboros\.ragnarok_active_attacker/);

for (const path of [
  "./data/incendium/function/item/firestorm/ray/iter.mcfunction",
  "./data/incendium/function/item/firestorm/ray/hit.mcfunction",
  "./data/incendium/function/item/firestorm/ray/hit_chain.mcfunction",
  "./data/incendium/function/item/patron/holy_wrath/explode.mcfunction",
  "./data/incendium/function/item/patron/holy_wrath/fireball_explode.mcfunction",
]) {
  assertNoIndiscriminateDamage(await read(path), path);
}

for (const weapon of ["firestorm", "ragnarok"]) {
  const damage = await read(
    `./data/ouroboros_incendium_hotfix/function/damage/${weapon}.mcfunction`,
  );
  assert.match(damage, /unless entity @s\[type=player\] run damage @s/);
  assert.match(damage, /if entity @s\[type=player,team=\] run damage @s/);
  assert.match(damage, /if entity @s\[type=player,team=COMBAT_TEAM\] run damage @s/);
  assert.match(damage, new RegExp(`tag=ouroboros\\.${weapon}_active_attacker`));
  assert.match(damage, new RegExp(`by @a\\[tag=ouroboros\\.${weapon}_owner,limit=1\\]`));
  assert.match(damage, /minecraft:fireworks/);
  assert.doesNotMatch(damage, /PASSIVE_TEAM/);
}

const firestormArrow = await read(
  "./data/incendium/function/item/firestorm/arrow.mcfunction",
);
assert.match(firestormArrow, /team=\] run tag @s add ouroboros\.firestorm_active_attacker/);
assert.match(firestormArrow, /team=COMBAT_TEAM\] run tag @s add ouroboros\.firestorm_active_attacker/);
assert.match(firestormArrow, /tag @a remove ouroboros\.firestorm_active_attacker/);

const holyWrathDamage = await read(
  "./data/ouroboros_incendium_hotfix/function/damage/holy_wrath.mcfunction",
);
assert.match(holyWrathDamage, /unless entity @s\[type=player\] run damage @s/);
assert.match(holyWrathDamage, /unless entity @s\[tag=ouroboros\.holy_wrath_owner\]/);
assert.match(holyWrathDamage, /tag=ouroboros\.holy_wrath_active_attacker/);
assert.match(holyWrathDamage, /@s\[type=player,team=\]/);
assert.match(holyWrathDamage, /@s\[type=player,team=COMBAT_TEAM\]/);
assert.match(holyWrathDamage, /minecraft:fireworks by @a\[tag=ouroboros\.holy_wrath_owner,limit=1\]/);
assert.doesNotMatch(holyWrathDamage, /PASSIVE_TEAM/);

const holyWrathFireball = await read(
  "./data/incendium/function/item/patron/holy_wrath/fireball_explode.mcfunction",
);
assert.match(holyWrathFireball, /type=#incendium:mobs,/);
assert.match(holyWrathFireball, /function ouroboros_incendium_hotfix:holy_wrath\/tag_owner with storage/);
assert.match(holyWrathFireball, /tag @a\[tag=ouroboros\.holy_wrath_owner\] remove ouroboros\.holy_wrath_owner/);

const holyWrathOwnerMacro = await read(
  "./data/ouroboros_incendium_hotfix/function/holy_wrath/tag_owner.mcfunction",
);
assert.match(holyWrathOwnerMacro, /^\$tag @a\[nbt=\{UUID:\$\(UUID\)\}\] add ouroboros\.holy_wrath_owner/m);
assert.match(holyWrathOwnerMacro, /team=\] run tag @s add ouroboros\.holy_wrath_active_attacker/);
assert.match(holyWrathOwnerMacro, /team=COMBAT_TEAM\] run tag @s add ouroboros\.holy_wrath_active_attacker/);

const headlessCase = await read("./headless-test.mjs");
assert.match(headlessCase, /team=PASSIVE_TEAM/);
assert.doesNotMatch(headlessCase, /kill @e\[type=#incendium:mobs_no_player/);
assert.match(headlessCase, /scoreboard players set \$\{attackerName\} in\.cd_wrath 0/);
assert.match(headlessCase, /attackerMinimumHealth/);
assert.match(headlessCase, /off-axis PvE target took no Trailblazer AoE damage/);
assert.match(headlessCase, /attackerPvp === "off" \|\| victimPvp === "off"/);

const harnessPatch = await read("./test-harness.patch");
assert.match(harnessPatch, /"start_use_item"/);
assert.match(harnessPatch, /"release_use_item"/);
assert.match(harnessPatch, /public async startUseItem/);
assert.match(harnessPatch, /public async releaseUseItem/);

const headlessMatrix = await read("./headless-matrix.mjs");
for (const weapon of [
  "trailblazer",
  "ragnarok",
  "firestorm",
  "holy_wrath",
  "multiplex_crossbow",
  "sentrys_wrath",
]) {
  assert.match(headlessMatrix, new RegExp(`weapon: "${weapon}"`));
}
assert.match(headlessMatrix, /name: "multiplex-arrow-passive-target"/);
assert.match(headlessMatrix, /name: "multiplex-rocket-passive-target"/);
assert.match(headlessMatrix, /name: "trailblazer-rejected-shot"/);
assert.match(headlessMatrix, /name: "ragnarok-rejected-shot"/);
assert.match(headlessMatrix, /name: "trailblazer-passive-shooter"/);
assert.match(headlessMatrix, /name: "firestorm-passive-shooter"/);
assert.match(headlessMatrix, /name: "holy-wrath-passive-shooter"/);
assert.match(headlessMatrix, /name: "ragnarok-passive-shooter"/);
assert.match(headlessMatrix, /name: "multiplex-arrow-passive-shooter"/);
assert.match(headlessMatrix, /name: "multiplex-rocket-passive-shooter"/);
assert.match(headlessMatrix, /name: "sentry-passive-shooter"/);
assert.match(headlessMatrix, /name: "sentry-pointblank"/);
assert.match(headlessMatrix, /name: "trailblazer-pve-aoe"[^\n]+pve: true/);
assert.match(headlessMatrix, /name: "trailblazer-pointblank"[^\n]+attackerAfterShotZ: 26[^\n]+active: true/);
assert.match(headlessMatrix, /name: "sentry-pointblank"[^\n]+victimPvp: "on"[^\n]+attackerAfterShotZ: 6[^\n]+active: true/);

console.log("Incendium 26.2 / PvP Toggle hotfix checks passed.");
