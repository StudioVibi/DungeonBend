import { mkdir, readFile, writeFile } from "node:fs/promises";
import path from "node:path";

type DefMap = Map<string, string[]>;

function parseStringDefs(source: string): DefMap {
  const defs: DefMap = new Map();
  const lines = source.split(/\r?\n/);

  let currentName: string | null = null;
  let currentBody: string[] = [];

  const flush = () => {
    if (currentName !== null) {
      defs.set(currentName, currentBody);
    }
  };

  for (const line of lines) {
    const defMatch = line.match(/^def ([A-Za-z0-9_]+)\(\) -> String:$/);

    if (defMatch) {
      flush();
      currentName = defMatch[1];
      currentBody = [];
      continue;
    }

    if (currentName !== null) {
      currentBody.push(line);
    }
  }

  flush();
  return defs;
}

function parseStringLiteral(expr: string): string | null {
  if (!expr.startsWith('"') || !expr.endsWith('"')) {
    return null;
  }

  return JSON.parse(expr);
}

function renderDef(name: string, defs: DefMap, cache: Map<string, string>, stack: string[]): string {
  const cached = cache.get(name);
  if (cached !== undefined) {
    return cached;
  }

  if (stack.includes(name)) {
    throw new Error(`Recursive String def detected: ${[...stack, name].join(" -> ")}`);
  }

  const body = defs.get(name);
  if (!body) {
    throw new Error(`Missing String def: ${name}`);
  }

  let output = "";

  for (const rawLine of body) {
    const line = rawLine.trim();
    if (line === "" || line.startsWith("#")) {
      continue;
    }

    const expr = line.startsWith("++ ") ? line.slice(3).trim() : line;

    if (expr === '""') {
      continue;
    }

    const literal = parseStringLiteral(expr);
    if (literal !== null) {
      output += literal;
      continue;
    }

    const callMatch = expr.match(/^([A-Za-z0-9_]+)\(\)$/);
    if (!callMatch) {
      throw new Error(`Unsupported String expression in ${name}: ${expr}`);
    }

    output += renderDef(callMatch[1], defs, cache, [...stack, name]);
  }

  cache.set(name, output);
  return output;
}

function rewriteCssAssetUrls(renderedCss: string): string {
  return renderedCss.replace(/url\((["']?)assets\//g, 'url($1../');
}

async function main() {
  const rootDir = process.cwd();
  const cssModulePath = path.join(rootDir, "src", "Dungeon", "View", "css.bend");
  const assetsModulePath = path.join(rootDir, "src", "Dungeon", "View", "assets_and_labels.bend");
  const outPath = path.join(rootDir, "assets", "generated", "dungeon-view.css");

  const [cssModule, assetsModule] = await Promise.all([
    readFile(cssModulePath, "utf8"),
    readFile(assetsModulePath, "utf8"),
  ]);

  const defs = new Map([
    ...parseStringDefs(assetsModule),
    ...parseStringDefs(cssModule),
  ]);

  const renderedCss = rewriteCssAssetUrls(renderDef("css", defs, new Map(), []));

  await mkdir(path.dirname(outPath), { recursive: true });
  await writeFile(
    outPath,
    `/* Generated from src/Dungeon/View/css.bend. */\n${renderedCss}\n`,
    "utf8",
  );
}

await main();
