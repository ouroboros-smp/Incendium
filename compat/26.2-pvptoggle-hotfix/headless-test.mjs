import { writeFileSync } from "node:fs";
import { pathToFileURL } from "node:url";

const harnessRoot = process.env.OURO_HARNESS_ROOT;
if (!harnessRoot) throw new Error("OURO_HARNESS_ROOT is required");
const { ProtocolClient } = await import(pathToFileURL(`${harnessRoot}/dist/client.js`).href);

const host = "23.139.82.230";
const port = 25566;
const version = "26.2";
const adminName = "RawnTheReaver";
const attackerName = process.env.ATTACKER_NAME ?? "IncendAtkA26";
const victimName = process.env.VICTIM_NAME ?? "IncendOffA26";
const ammo = process.env.AMMO ?? "arrow";
const weapon = process.env.WEAPON ?? "multiplex_crossbow";
const postShotMs = Number(process.env.POST_SHOT_MS ?? "2000");
const chargeMs = Number(process.env.CHARGE_MS ?? "2000");
const victimZ = Number(process.env.VICTIM_Z ?? "8");
const victimX = Number(process.env.VICTIM_X ?? "0");
const wallZ = Number(process.env.WALL_Z ?? "10");
const pveProbe = process.env.PVE_PROBE === "1";
const pveX = Number(process.env.PVE_X ?? "2");
const attackerAfterShotZ = !process.env.ATTACKER_AFTER_SHOT_Z
  ? null
  : Number(process.env.ATTACKER_AFTER_SHOT_Z);
const attackerAfterShotDelayMs = Number(process.env.ATTACKER_AFTER_SHOT_DELAY_MS ?? "300");
const arenaMaxZ = Math.max(12, wallZ + 2);
const attackerPvp = process.env.ATTACKER_PVP ?? "on";
const victimPvp = process.env.VICTIM_PVP ?? "off";
const admin = new ProtocolClient({ name: "admin", username: adminName }, host, port, version);
const attacker = new ProtocolClient({ name: "attacker", username: attackerName }, host, port, version);
const victim = new ProtocolClient({ name: "victim", username: victimName }, host, port, version);
const delay = (milliseconds) => new Promise((resolve) => setTimeout(resolve, milliseconds));
const messages = (client, since = 0) => client.events.slice(since).filter((event) => event.type === "message");

async function health(client) {
  const value = Number((await client.state()).health);
  if (!Number.isFinite(value)) throw new Error(`invalid health value: ${value}`);
  return value;
}

async function playerIsPassive(playerName) {
  const baseline = admin.events.length;
  const marker = `[PVP-STATE-${Date.now()}]`;
  await admin.chat(`/execute if entity @a[name=${playerName},team=PASSIVE_TEAM] run tellraw ${adminName} {"text":"${marker}"}`);
  await delay(1_000);
  return messages(admin, baseline).some((event) => event.data.message.includes(marker));
}

async function ensurePvpState(client, playerName, state) {
  const wantsPassive = state === "off";
  if (await playerIsPassive(playerName) !== wantsPassive) {
    await client.chat("/pvp");
    await delay(5_000);
  }
  if (await playerIsPassive(playerName) !== wantsPassive) {
    throw new Error(`failed to set ${playerName} PvP ${state}`);
  }
}

let failure;
let result;
try {
  await admin.connect(45_000);
  if (process.env.RELOAD === "1") {
    await admin.chat("/reload");
    await delay(12_000);
  }
  await delay(4_000);
  await attacker.connect(45_000);
  await delay(4_000);
  await victim.connect(45_000);
  await delay(2_000);

  await ensurePvpState(attacker, attackerName, attackerPvp);
  await ensurePvpState(victim, victimName, victimPvp);

  const attackerMessageBaseline = attacker.events.length;
  const victimMessageBaseline = victim.events.length;
  await admin.chat("/say incendium-headless-op-probe");
  await admin.chat(`/gamemode survival ${attackerName}`);
  await admin.chat(`/gamemode survival ${victimName}`);
  await admin.chat(`/effect clear ${attackerName}`);
  await admin.chat(`/effect clear ${victimName}`);
  await admin.chat(`/clear ${attackerName}`);
  await admin.chat(`/clear ${victimName}`);
  await admin.chat("/weather clear");
  for (const entityType of ["arrow", "spectral_arrow", "firework_rocket", "small_fireball", "marker"]) {
    await admin.chat(`/execute positioned 0 120 0 run kill @e[type=minecraft:${entityType},distance=..30]`);
  }
  await admin.chat(`/fill -4 119 -2 4 125 ${arenaMaxZ} minecraft:air`);
  await admin.chat(`/fill -4 119 -2 4 119 ${arenaMaxZ} minecraft:stone`);
  await admin.chat(`/fill -4 125 -2 4 125 ${arenaMaxZ} minecraft:stone`);
  await admin.chat(`/fill -4 120 -2 -4 124 ${arenaMaxZ} minecraft:stone`);
  await admin.chat(`/fill 4 120 -2 4 124 ${arenaMaxZ} minecraft:stone`);
  await admin.chat("/fill -4 120 -2 4 124 -2 minecraft:stone");
  await admin.chat(`/fill -4 120 ${wallZ} 4 124 ${wallZ} minecraft:stone`);
  await admin.chat(`/execute in minecraft:overworld run tp ${adminName} 10 120 0 0 0`);
  await admin.chat(`/execute in minecraft:overworld run tp ${attackerName} 0 120 0 0 0`);
  await admin.chat(`/execute in minecraft:overworld run tp ${victimName} ${victimX} 120 ${victimZ} 180 0`);
  await admin.chat(`/effect give ${attackerName} minecraft:instant_health 1 10 true`);
  await admin.chat(`/effect give ${victimName} minecraft:instant_health 1 10 true`);
  await admin.chat(`/effect give ${attackerName} minecraft:saturation 1 10 true`);
  await admin.chat(`/effect give ${victimName} minecraft:saturation 1 10 true`);
  await admin.chat(`/execute as ${attackerName} run function incendium:admin/give/${weapon}`);
  await admin.chat(`/scoreboard players set ${attackerName} in.cd_wrath 0`);
  if (process.env.FORCE_COOLDOWN === "1") {
    await admin.chat(`/scoreboard players set ${attackerName} in.cd_wrath 60`);
  }
  if (ammo === "rocket") {
    await admin.chat(`/item replace entity ${attackerName} weapon.offhand with minecraft:firework_rocket[minecraft:fireworks={flight_duration:1,explosions:[{shape:'small_ball',colors:[16711680]}]}] 64`);
  } else if (ammo === "spectral") {
    await admin.chat(`/give ${attackerName} minecraft:spectral_arrow 64`);
  } else {
    await admin.chat(`/give ${attackerName} minecraft:arrow 64`);
  }
  if (pveProbe) {
    await admin.chat("/kill @e[type=minecraft:zombie,tag=ouroboros.incendium_pve_probe]");
    await admin.chat(`/summon minecraft:zombie ${pveX} 120 ${victimZ} {Tags:["ouroboros.incendium_pve_probe"],NoAI:1b,Silent:1b,PersistenceRequired:1b,Health:20.0f}`);
  }
  await delay(2_000);

  const setupState = await attacker.state();
  const weaponSlot = setupState.inventory?.find(
    (entry) => entry && entry.slot >= 36 && entry.slot <= 44
      && ["minecraft:bow", "minecraft:crossbow"].includes(entry.item),
  )?.slot;
  if (!Number.isInteger(weaponSlot)) {
    throw new Error(`weapon setup failed for ${weapon}: ${JSON.stringify(setupState.inventory)}`);
  }
  await attacker.selectHotbar(weaponSlot - 36);
  await attacker.look(0, 0);
  const attackerBefore = await health(attacker);
  const victimBefore = await health(victim);
  const attackerStateBefore = await attacker.state();
  const heldItem = attackerStateBefore.inventory?.find((entry) => entry?.slot === weaponSlot);
  if (!heldItem || !["minecraft:bow", "minecraft:crossbow"].includes(heldItem.item)) {
    throw new Error(`weapon setup failed for ${weapon}: ${JSON.stringify(attackerStateBefore.inventory)}`);
  }
  const attackerShotBaseline = attacker.events.length;
  const victimShotBaseline = victim.events.length;
  const adminShotBaseline = admin.events.length;

  await attacker.startUseItem();
  if (process.env.PROBE_CHARGE === "1" && heldItem.item === "minecraft:bow") {
    const sampleMs = Math.max(100, Math.floor(chargeMs / 5));
    for (let sample = 0; sample < 5; sample += 1) {
      await delay(sampleMs);
      await admin.chat(`/tellraw ${adminName} [{"text":"[DEBUG-incendium-charge] "},{"score":{"name":"${attackerName}","objective":"in.${weapon}"}}]`);
    }
  } else {
    await delay(chargeMs);
  }
  await attacker.releaseUseItem();
  if (heldItem.item === "minecraft:crossbow") {
    await delay(300);
    await attacker.startUseItem();
  }
  if (Number.isFinite(attackerAfterShotZ)) {
    await delay(attackerAfterShotDelayMs);
    await admin.chat(`/execute in minecraft:overworld run tp ${attackerName} 0 120 ${attackerAfterShotZ} 0 0`);
  }
  await delay(postShotMs);

  let pveDamage;
  if (pveProbe) {
    const pveMessageBaseline = admin.events.length;
    await admin.chat("/scoreboard objectives add ouro_pve_health dummy");
    await admin.chat("/scoreboard players set #alive ouro_pve_health 0");
    await admin.chat("/execute if entity @e[type=minecraft:zombie,tag=ouroboros.incendium_pve_probe,limit=1] run scoreboard players set #alive ouro_pve_health 1");
    await admin.chat("/scoreboard players set #health ouro_pve_health 0");
    await admin.chat("/execute store result score #health ouro_pve_health run data get entity @e[type=minecraft:zombie,tag=ouroboros.incendium_pve_probe,limit=1] Health 100");
    await admin.chat(`/tellraw ${adminName} [{"text":"[PVE-ALIVE] "},{"score":{"name":"#alive","objective":"ouro_pve_health"}}]`);
    await admin.chat(`/tellraw ${adminName} [{"text":"[PVE-HEALTH] "},{"score":{"name":"#health","objective":"ouro_pve_health"}}]`);
    await delay(1_000);
    const pveMessages = messages(admin, pveMessageBaseline).map((event) => event.data.message);
    const alive = Number(pveMessages.find((message) => message.startsWith("[PVE-ALIVE] "))?.split(" ").at(-1));
    const scaledHealth = Number(pveMessages.find((message) => message.startsWith("[PVE-HEALTH] "))?.split(" ").at(-1));
    if (!Number.isFinite(alive) || !Number.isFinite(scaledHealth)) {
      throw new Error(`failed to read PvE probe health: ${JSON.stringify(pveMessages)}`);
    }
    pveDamage = alive === 0 ? 20 : 20 - (scaledHealth / 100);
  }

  const attackerAfter = await health(attacker);
  const victimAfter = await health(victim);
  const attackerStateAfter = await attacker.state();
  const attackerHealthSamples = attacker.events.slice(attackerShotBaseline)
    .filter((event) => event.type === "health")
    .map((event) => Number(event.data.health));
  const victimHealthSamples = victim.events.slice(victimShotBaseline)
    .filter((event) => event.type === "health")
    .map((event) => Number(event.data.health));
  const attackerDied = attacker.events.slice(attackerShotBaseline).some((event) => event.type === "death");
  const victimDied = victim.events.slice(victimShotBaseline).some((event) => event.type === "death");
  const attackerMinimumHealth = Math.min(attackerBefore, ...attackerHealthSamples, attackerDied ? 0 : Infinity);
  const victimMinimumHealth = Math.min(victimBefore, ...victimHealthSamples, victimDied ? 0 : Infinity);
  result = {
    weapon,
    ammo,
    attackerPvp,
    victimPvp,
    attackerBefore,
    attackerAfter,
    attackerMinimumHealth,
    attackerDamage: attackerBefore - attackerMinimumHealth,
    victimBefore,
    victimAfter,
    victimMinimumHealth,
    victimDamage: victimBefore - victimMinimumHealth,
    pveDamage,
    attackerStateBefore,
    attackerStateAfter,
    attackerMessages: messages(attacker, attackerMessageBaseline),
    victimMessages: messages(victim, victimMessageBaseline),
    adminShotMessages: messages(admin, adminShotBaseline),
  };

  if (process.env.ASSERT_SAFE === "1") {
    if (result.attackerDamage > 0.001) {
      throw new Error(`shooter took ${result.attackerDamage} damage: ${JSON.stringify(result)}`);
    }
    if ((attackerPvp === "off" || victimPvp === "off") && result.victimDamage > 0.001) {
      throw new Error(`PvP-off target took ${result.victimDamage} damage: ${JSON.stringify(result)}`);
    }
  }
  if (process.env.ASSERT_ACTIVE_DAMAGE === "1" && result.victimDamage <= 0.001) {
    throw new Error(`PvP-on target took no damage: ${JSON.stringify(result)}`);
  }
  if (pveProbe && !(result.pveDamage > 0.001)) {
    throw new Error(`off-axis PvE target took no Trailblazer AoE damage: ${JSON.stringify(result)}`);
  }
} catch (error) {
  failure = error instanceof Error ? { message: error.message, stack: error.stack } : { message: String(error) };
} finally {
  try { await admin.chat(`/clear ${attackerName}`); } catch {}
  try { await admin.chat(`/clear ${victimName}`); } catch {}
  try { await admin.chat("/execute positioned 0 120 0 run kill @e[type=minecraft:arrow,distance=..30]"); } catch {}
  try { await admin.chat("/execute positioned 0 120 0 run kill @e[type=minecraft:spectral_arrow,distance=..30]"); } catch {}
  try { await admin.chat("/execute positioned 0 120 0 run kill @e[type=minecraft:firework_rocket,distance=..30]"); } catch {}
  try { await admin.chat("/execute positioned 0 120 0 run kill @e[type=minecraft:small_fireball,distance=..30]"); } catch {}
  try { await admin.chat("/execute positioned 0 120 0 run kill @e[type=minecraft:marker,distance=..30]"); } catch {}
  try { await admin.chat("/kill @e[type=minecraft:zombie,tag=ouroboros.incendium_pve_probe]"); } catch {}
  try { await admin.chat(`/fill -4 119 -2 4 125 ${arenaMaxZ} minecraft:air`); } catch {}
  await delay(250);
  try { await admin.disconnect("Incendium staging repro complete"); } catch {}
  try { await attacker.disconnect("Incendium staging repro complete"); } catch {}
  try { await victim.disconnect("Incendium staging repro complete"); } catch {}
  writeFileSync(new URL("./headless-result.json", import.meta.url), JSON.stringify({
    generatedAt: new Date().toISOString(),
    target: `${host}:${port}`,
    result,
    failure,
    adminEvents: admin.events,
    attackerEvents: attacker.events,
    victimEvents: victim.events,
  }, null, 2));
}

if (failure) {
  console.error(failure.stack ?? failure.message);
  process.exitCode = 1;
} else {
  console.log(JSON.stringify(result, null, 2));
}
