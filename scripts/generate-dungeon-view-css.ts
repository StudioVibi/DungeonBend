import { mkdir, readFile, readdir, writeFile } from "node:fs/promises";
import path from "node:path";

type DefMap = Map<string, string[]>;

async function readBendFilesRecursive(dir: string): Promise<string[]> {
  let entries;
  try {
    entries = await readdir(dir, { withFileTypes: true });
  } catch (err) {
    if ((err as NodeJS.ErrnoException).code === "ENOENT") {
      return [];
    }
    throw err;
  }

  const chunks = await Promise.all(
    entries.map(async (entry) => {
      const entryPath = path.join(dir, entry.name);
      if (entry.isDirectory()) {
        return readBendFilesRecursive(entryPath);
      }
      if (entry.isFile() && entry.name.endsWith(".bend")) {
        return [await readFile(entryPath, "utf8")];
      }
      return [];
    }),
  );

  return chunks.flat();
}

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

// Returns true if `s` starts with `"` and contains a matching unescaped `"`.
// Used to detect when a `++ "..."` literal spans multiple physical lines.
function isCompleteStringLiteral(s: string): boolean {
  if (!s.startsWith('"')) return false;
  let escaped = false;
  for (let j = 1; j < s.length; j++) {
    const c = s[j];
    if (escaped) {
      escaped = false;
      continue;
    }
    if (c === "\\") {
      escaped = true;
      continue;
    }
    if (c === '"') {
      return true;
    }
  }
  return false;
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
  let i = 0;

  while (i < body.length) {
    const line = body[i].trim();
    if (line === "" || line.startsWith("#")) {
      i++;
      continue;
    }

    let expr = line.startsWith("++ ") ? line.slice(3).trim() : line;

    if (expr === '""') {
      i++;
      continue;
    }

    // Support multi-line `++ "..."` literals: if the string starts but does
    // not close on this line, keep absorbing trimmed lines (joined with a
    // single space, since whitespace is insignificant in CSS) until the
    // closing quote appears.
    if (expr.startsWith('"') && !isCompleteStringLiteral(expr)) {
      const parts = [expr];
      i++;
      while (i < body.length) {
        parts.push(body[i].trim());
        i++;
        if (isCompleteStringLiteral(parts.join(" "))) {
          break;
        }
      }
      expr = parts.join(" ");
    } else {
      i++;
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
  const cssModuleDir = path.join(rootDir, "src", "Dungeon", "View", "action_button_css");
  const outPath = path.join(rootDir, "assets", "generated", "dungeon-view.css");

  const [cssModule, assetsModule, cssModules] = await Promise.all([
    readFile(cssModulePath, "utf8"),
    readFile(assetsModulePath, "utf8"),
    readBendFilesRecursive(cssModuleDir),
  ]);

  const defs = new Map([
    ...parseStringDefs(assetsModule),
    ...cssModules.flatMap((module) => [...parseStringDefs(module)]),
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
