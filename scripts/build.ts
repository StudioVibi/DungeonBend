import * as path from "node:path";
import * as process from "node:process";
import * as Bend from "../../Bend2/bend-ts/src/Bend.ts";

function usage(): never {
  console.error("usage: bun scripts/build.ts <input.bend> <output.html>");
  process.exit(1);
}

const input = process.argv[2];
const output = process.argv[3];

if (input === undefined || output === undefined) {
  usage();
}

const cwd = process.cwd();
const file = path.resolve(cwd, input);
const out = path.resolve(cwd, output);
const preludeDir = path.resolve(cwd, process.env.BEND_PRELUDE_DIR ?? "../Bend2/prelude");

const loaded = Bend.Loader.load_book(file, { prelude_dir: preludeDir, strict: true });
const ok = Bend.Core.check_book(loaded.book, {
  show_ok: false,
  write: process.stderr.write.bind(process.stderr),
});

if (!ok) {
  process.exit(1);
}

const html = Bend.ToJS.page(loaded.book, {
  main_name: loaded.main,
  title: path.basename(file, ".bend"),
});

await Bun.write(out, html);
