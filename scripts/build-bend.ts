import * as fs from "node:fs";
import * as path from "node:path";
import * as Mod from "../../Bend2/src/ts/Module.ts";
import * as Names from "../../Bend2/src/ts/Names.ts";
import * as ToJS from "../../Bend2/src/ts/Compile/ToJS.ts";

var root = path.resolve(import.meta.dirname, "..");
var bendEntry = path.join(root, "bend/main.bend");
var outDir = path.join(root, "src/generated");
var outJs = path.join(outDir, "bend-core.js");
var outDts = path.join(outDir, "bend-core.d.ts");
var outApi = path.join(outDir, "bend-api.ts");

type ExportDef = {
  exportName: string;
  refName: string;
};

var exportsToMap: ExportDef[] = [
  { exportName: "startRunCore", refName: "/bend/main/start_run" },
  { exportName: "upgradeHeroCore", refName: "/bend/main/upgrade_hero" },
  { exportName: "applySwipeCore", refName: "/bend/main/apply_swipe" },
];

function fastName(refName: string): string {
  return "$" + Names.code_name(refName);
}

function buildApiModule(): string {
  var lines = [
    "import * as core from \"./bend-core.js\";",
    "",
  ];

  for (var entry of exportsToMap) {
    lines.push("export const " + entry.exportName + " = core." + fastName(entry.refName) + ";");
  }

  lines.push("");
  return lines.join("\n");
}

function buildCoreDeclarations(): string {
  var lines: string[] = [];

  for (var entry of exportsToMap) {
    lines.push("export const " + fastName(entry.refName) + ": unknown;");
  }

  lines.push("");
  return lines.join("\n");
}

fs.mkdirSync(outDir, { recursive: true });

var loaded = Mod.load_book(bendEntry);
var js = ToJS.book(loaded.book, { run_main: false, main_name: null });

fs.writeFileSync(outJs, js, "utf8");
fs.writeFileSync(outDts, buildCoreDeclarations(), "utf8");
fs.writeFileSync(outApi, buildApiModule(), "utf8");
console.log("Built Bend core to " + path.relative(root, outJs));
