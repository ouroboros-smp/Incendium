import { spawnSync } from "node:child_process";
import { readFileSync } from "node:fs";
import { fileURLToPath } from "node:url";

const cases = [
  { name: "trailblazer-passive-target", weapon: "trailblazer", ammo: "arrow", attackerPvp: "on", victimPvp: "off", charge: 2200 },
  { name: "ragnarok-passive-target", weapon: "ragnarok", ammo: "arrow", attackerPvp: "on", victimPvp: "off", charge: 2200 },
  { name: "firestorm-passive-target", weapon: "firestorm", ammo: "spectral", attackerPvp: "on", victimPvp: "off" },
  { name: "holy-wrath-passive-target", weapon: "holy_wrath", ammo: "spectral", attackerPvp: "on", victimPvp: "off", post: 4000 },
  { name: "multiplex-arrow-passive-target", weapon: "multiplex_crossbow", ammo: "arrow", attackerPvp: "on", victimPvp: "off", victimZ: 4 },
  { name: "multiplex-rocket-passive-target", weapon: "multiplex_crossbow", ammo: "rocket", attackerPvp: "on", victimPvp: "off" },
  { name: "sentry-passive-target", weapon: "sentrys_wrath", ammo: "spectral", attackerPvp: "on", victimPvp: "off", post: 4000 },

  { name: "trailblazer-active", weapon: "trailblazer", ammo: "arrow", attackerPvp: "on", victimPvp: "on", charge: 2200, active: true },
  { name: "ragnarok-active", weapon: "ragnarok", ammo: "arrow", attackerPvp: "on", victimPvp: "on", charge: 2200, active: true },
  { name: "firestorm-active", weapon: "firestorm", ammo: "spectral", attackerPvp: "on", victimPvp: "on", active: true },
  { name: "holy-wrath-active", weapon: "holy_wrath", ammo: "spectral", attackerPvp: "on", victimPvp: "on", post: 4000, active: true },
  { name: "multiplex-arrow-active", weapon: "multiplex_crossbow", ammo: "arrow", attackerPvp: "on", victimPvp: "on", victimZ: 4, active: true },
  { name: "multiplex-rocket-active", weapon: "multiplex_crossbow", ammo: "rocket", attackerPvp: "on", victimPvp: "on", active: true },
  { name: "sentry-active", weapon: "sentrys_wrath", ammo: "spectral", attackerPvp: "on", victimPvp: "on", post: 4000, active: true },

  { name: "trailblazer-rejected-shot", weapon: "trailblazer", ammo: "arrow", attackerPvp: "on", victimPvp: "off", charge: 100 },
  { name: "ragnarok-rejected-shot", weapon: "ragnarok", ammo: "arrow", attackerPvp: "on", victimPvp: "off", charge: 100 },
  { name: "trailblazer-passive-shooter", weapon: "trailblazer", ammo: "arrow", attackerPvp: "off", victimPvp: "on", charge: 2200 },
  { name: "firestorm-passive-shooter", weapon: "firestorm", ammo: "spectral", attackerPvp: "off", victimPvp: "on" },
  { name: "holy-wrath-passive-shooter", weapon: "holy_wrath", ammo: "spectral", attackerPvp: "off", victimPvp: "on", post: 4000 },
  { name: "ragnarok-passive-shooter", weapon: "ragnarok", ammo: "arrow", attackerPvp: "off", victimPvp: "on", charge: 2200 },
  { name: "multiplex-arrow-passive-shooter", weapon: "multiplex_crossbow", ammo: "arrow", attackerPvp: "off", victimPvp: "on", victimZ: 4 },
  { name: "multiplex-rocket-passive-shooter", weapon: "multiplex_crossbow", ammo: "rocket", attackerPvp: "off", victimPvp: "on" },
  { name: "sentry-passive-shooter", weapon: "sentrys_wrath", ammo: "spectral", attackerPvp: "off", victimPvp: "on", post: 4000 },
  { name: "sentry-cooldown", weapon: "sentrys_wrath", ammo: "spectral", attackerPvp: "on", victimPvp: "off", post: 4000, cooldown: true },
  { name: "trailblazer-pve-aoe", weapon: "trailblazer", ammo: "arrow", attackerPvp: "on", victimPvp: "off", charge: 2200, victimX: 10, victimZ: 8, pve: true },
  { name: "trailblazer-pointblank", weapon: "trailblazer", ammo: "arrow", attackerPvp: "on", victimPvp: "on", charge: 2200, post: 5000, victimZ: 28, wallZ: 30, attackerAfterShotZ: 26, attackerAfterShotDelay: 50, active: true },
  { name: "sentry-pointblank", weapon: "sentrys_wrath", ammo: "spectral", attackerPvp: "on", victimPvp: "on", post: 4000, victimZ: 8, wallZ: 10, attackerAfterShotZ: 6, active: true },
];

const filter = process.env.HEADLESS_FILTER
  ? new RegExp(process.env.HEADLESS_FILTER)
  : null;
const selected = filter ? cases.filter((testCase) => filter.test(testCase.name)) : cases;
if (selected.length === 0) throw new Error("HEADLESS_FILTER selected no cases");

const runner = fileURLToPath(new URL("./headless-test.mjs", import.meta.url));
const resultFile = new URL("./headless-result.json", import.meta.url);
const results = [];
let failed = false;

for (const [index, testCase] of selected.entries()) {
  const child = spawnSync(process.execPath, [runner], {
    env: {
      ...process.env,
      WEAPON: testCase.weapon,
      AMMO: testCase.ammo,
      ATTACKER_PVP: testCase.attackerPvp,
      VICTIM_PVP: testCase.victimPvp,
      CHARGE_MS: String(testCase.charge ?? 1800),
      POST_SHOT_MS: String(testCase.post ?? 3000),
      VICTIM_Z: String(testCase.victimZ ?? 8),
      VICTIM_X: String(testCase.victimX ?? 0),
      WALL_Z: String(testCase.wallZ ?? 10),
      PVE_PROBE: testCase.pve ? "1" : "0",
      PVE_X: String(testCase.pveX ?? 2),
      ATTACKER_AFTER_SHOT_Z: testCase.attackerAfterShotZ === undefined ? "" : String(testCase.attackerAfterShotZ),
      ATTACKER_AFTER_SHOT_DELAY_MS: String(testCase.attackerAfterShotDelay ?? 300),
      FORCE_COOLDOWN: testCase.cooldown ? "1" : "0",
      ASSERT_SAFE: "1",
      ASSERT_ACTIVE_DAMAGE: testCase.active ? "1" : "0",
      RELOAD: index === 0 && process.env.HEADLESS_RELOAD === "1" ? "1" : "0",
    },
    stdio: ["ignore", "ignore", "inherit"],
  });
  const report = JSON.parse(readFileSync(resultFile, "utf8"));
  const row = {
    case: testCase.name,
    exit: child.status,
    shooterDamage: report.result?.attackerDamage,
    targetDamage: report.result?.victimDamage,
    pveDamage: report.result?.pveDamage,
    failure: report.failure?.message,
  };
  results.push(row);
  console.log(JSON.stringify(row));
  if (child.status !== 0) failed = true;
}

console.table(results);
if (failed) process.exitCode = 1;
