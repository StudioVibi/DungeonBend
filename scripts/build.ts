import * as path from "node:path";
import * as process from "node:process";
import * as Bend from "../../Bend2/bend-ts/src/Bend.ts";

function patchAppRuntime(html: string): string {
  const childPatchBuggy = [
    "    var nxt = __app_patch(kid, prev.kids[i], next.kids[i], dispatch, kidSvg);",
    "    if (nxt !== kid) {",
      "      dom.replaceChild(nxt, kid);",
    "    }",
  ].join("\n");

  const childPatchFixed = [
    "    var nxt = __app_patch(kid, prev.kids[i], next.kids[i], dispatch, kidSvg);",
    "    if (nxt !== kid && kid.parentNode === dom) {",
    "      dom.replaceChild(nxt, kid);",
    "    }",
  ].join("\n");

  const replaceBuggy = [
    "function __app_replace(dom, view, dispatch, svg) {",
    "  var nxt = __app_mount(view, dispatch, svg);",
    "  __app_dispose(dom);",
    "  dom.replaceWith(nxt);",
    "  return nxt;",
    "}",
  ].join("\n");

  const replaceFixed = [
    "function __app_replace(dom, view, dispatch, svg) {",
    "  var nxt = __app_mount(view, dispatch, svg);",
    "  __app_dispose(dom);",
    "  return nxt;",
    "}",
  ].join("\n");

  const stepBuggy = [
    "    dom  = __app_patch(dom, view, next, step, false);",
    "    view = next;",
  ].join("\n");

  const stepFixed = [
    "    dom  = __app_patch(dom, view, next, step, false);",
    "    if (dom.parentNode !== root) {",
    "      root.replaceChildren(dom);",
    "    }",
    "    view = next;",
  ].join("\n");

  let out = html;
  if (out.includes(childPatchBuggy)) {
    out = out.replace(childPatchBuggy, childPatchFixed);
  }
  if (out.includes(replaceBuggy)) {
    out = out.replace(replaceBuggy, replaceFixed);
  }
  if (out.includes(stepBuggy)) {
    out = out.replace(stepBuggy, stepFixed);
  }
  return out;
}

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

const html = patchAppRuntime(Bend.ToJS.page(loaded.book, {
  main_name: loaded.main,
  title: path.basename(file, ".bend"),
}));

await Bun.write(out, html);
