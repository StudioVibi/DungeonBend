import * as fs from "node:fs/promises";
import * as path from "node:path";
import * as process from "node:process";
import { pathToFileURL } from "node:url";
import { generateDungeonConfig as generateDungeonData } from "./dungeon-data.ts";

type BendLayout =
  | { kind: "legacy"; bendSrcDir: string; preludeDir: string }
  | { kind: "current"; bendSrcDir: string };

async function pathExists(target: string) {
  try {
    await fs.access(target);
    return true;
  } catch {
    return false;
  }
}

async function resolveLocalBendLayout(cwd: string): Promise<BendLayout> {
  const repoRoots = [
    process.env.BEND_DIR ? path.resolve(cwd, process.env.BEND_DIR) : null,
    path.resolve(cwd, "../Bend2"),
  ].filter((value): value is string => value !== null);

  for (const repoRoot of repoRoots) {
    const currentBendSrcDir = path.join(repoRoot, "bend", "src");
    const currentEntry = path.join(currentBendSrcDir, "Bend.ts");
    if (await pathExists(currentEntry)) {
      return { kind: "current", bendSrcDir: currentBendSrcDir };
    }

    const legacyBendSrcDir = path.join(repoRoot, "bend-ts", "src");
    const legacyEntry = path.join(legacyBendSrcDir, "Bend.ts");
    const legacyPreludeDir = path.join(repoRoot, "prelude");
    if (await pathExists(legacyEntry)) {
      return { kind: "legacy", bendSrcDir: legacyBendSrcDir, preludeDir: legacyPreludeDir };
    }
  }

  throw new Error(
    "Local Bend2 repo not found. Set BEND_DIR or provide ../Bend2 with bend/src/Bend.ts or bend-ts/src/Bend.ts."
  );
}

async function loadPatchedBend(layout: BendLayout) {
  if (layout.kind === "current") {
    const bendRepoRoot = path.resolve(layout.bendSrcDir, "..", "..");
    const patchedRepoRoot = path.resolve(process.env.TMPDIR ?? "/tmp", `dungeonbend-bend2-repo-${process.pid}`);
    const patchedBendRoot = path.join(patchedRepoRoot, "bend");
    const patchedBirlRoot = path.join(patchedRepoRoot, "birl");
    const patchedBaseRoot = path.join(patchedRepoRoot, "base");
    const langPath = path.join(patchedBendRoot, "src", "Lang.ts");
    const originalResolveFile = `export function Loader$resolve_file(nam: string, st: Loader$State): string | null {
  var rel = Lib$path.join(...nam.split("/"), "_.bend");
  var loc = Loader$resolve_file$exact(st.root, rel);
  if (loc !== null) {
    return loc;
  }
  var bas = Loader$resolve_file$exact(st.prelude_dir, rel);
  if (bas !== null) {
    return bas;
  }
  if (st.short_index === null) {
    st.short_index = Loader$short_index$build(st);
  }
  var ful = st.short_index.get(nam);
  if (ful !== undefined) {
    return Lib$path.join(st.prelude_dir, ...ful.split("/"), "_.bend");
  }
  return null;
}`;
    const patchedResolveFile = `export function Loader$resolve_file(nam: string, st: Loader$State): string | null {
  var parts = nam.split("/");
  var dir_rel = Lib$path.join(...parts, "_.bend");
  var file_rel = Lib$path.join(...parts) + ".bend";
  var loc = Loader$resolve_file$exact(st.root, dir_rel);
  if (loc !== null) {
    return loc;
  }
  var fil = Loader$resolve_file$exact(st.root, file_rel);
  if (fil !== null) {
    return fil;
  }
  for (var end = parts.length - 1; end >= 1; --end) {
    var parent_file = Loader$resolve_file$exact(st.root, Lib$path.join(...parts.slice(0, end)) + ".bend");
    if (parent_file !== null) {
      return parent_file;
    }
    var anc = Loader$resolve_file$exact(st.root, Lib$path.join(...parts.slice(0, end), "_.bend"));
    if (anc !== null) {
      return anc;
    }
  }
  var bas = Loader$resolve_file$exact(st.prelude_dir, dir_rel);
  if (bas !== null) {
    return bas;
  }
  if (st.short_index === null) {
    st.short_index = Loader$short_index$build(st);
  }
  var ful = st.short_index.get(nam);
  if (ful !== undefined) {
    return Lib$path.join(st.prelude_dir, ...ful.split("/"), "_.bend");
  }
  return null;
}`;
    const originalFileId = `export function Loader$file_id(file: string, st: Loader$State): string | null {
  var base = Lib$path.basename(file);
  if (base !== "_.bend") {
    return null;
  }
  var in_prelude = file.startsWith(st.prelude_dir + Lib$path.sep);
  var root = in_prelude ? st.prelude_dir : st.root;
  var seg = Lib$path.relative(root, Lib$path.dirname(file)).split(Lib$path.sep);
  if (seg.length === 0 || seg[0] === "") {
    return null;
  }
  if (in_prelude) {
    var top = seg[0];
    if (Loader$short_index$strip_root(seg) && seg.length >= 2) {
      return seg.slice(1).join("/");
    }
  }
  return seg.join("/");
}`;
    const originalNotePendingDefs = `export function Loader$note_pending_defs(defs: [string, Core$.Def][], fid: string | null, st: Loader$State): void {
  for (var [raw_nam] of defs) {
    if (raw_nam.includes("/")) {
      st.pending.add(Loader$def_name(fid, raw_nam));
    }
  }
}`;
    const originalLoadImport = `export function Loader$load_import(
  imp: Parser$Import,
  file: string,
  als: Map<string, string>,
  st: Loader$State,
): void {
  var loc = Loader$resolve_file(imp.path, st);
  if (loc === null) {
    throw new Error("error: import not found '" + imp.path + "'\\n  imported from: " + file);
  }
  Loader$load_file(loc, st);
  if (!st.book.has(imp.path)) {
    throw new Error("error: imported file does not define '" + imp.path + "'\\n  imported from: " + file);
  }
  als.set(imp.alias, imp.path);
}`;
    const originalNativeType = `export function Compile$ToBIRL$lower$native_type(
  book: Core$.Book | null,
  typ: Core$.Term | null,
): "char" | "string" | null {
  if (book === null) {
    return null;
  }
  var typ = Core$.Term$force(book, typ);
  if (typ === null || typ.$ !== "ADT") {
    return null;
  }
  // Check char: single constructor char{U32}
  if (Compile$ToBIRL$lower$native_type$is_char_adt(book, typ)) {
    return "char";
  }
  // Check string: nil{} + cons{Char, self} (not List(Char))
  if (typ.ctrs.length === 2) {
    var [nil_ctr] = Core$.Term$take_ctr(typ, "nil");
    var [cons_ctr] = Core$.Term$take_ctr(typ, "cons");
    var is_str_shape = nil_ctr !== null
      && Core$.Tele$fields(nil_ctr.fds).length === 0
      && cons_ctr !== null;
    if (is_str_shape) {
      var c_flds = Core$.Tele$fields(cons_ctr!.fds);
      if (c_flds.length === 2) {
        var hed = Core$.Term$force(book, c_flds[0].typ);
        var raw = Core$.Term$Peel(c_flds[1].typ, "reduced");
        if (hed !== null && hed.$ === "ADT" && Compile$ToBIRL$lower$native_type$is_char_adt(book, hed) && raw.$ !== "App") {
          return "string";
        }
      }
    }
  }
  return null;
}`;
    const originalAdtKey = `export function Compile$ToBIRL$lower$apply$ctr_tag$adt_key(adt: Core$.Term$ADT): string {
  var out: string[] = [];
  for (var ctr of adt.ctrs) {
    var cnt = 0;
    for (var _fld of Core$.Tele$fields(ctr.fds)) {
      cnt += 1;
    }
    out.push(ctr.nam + "/" + String(cnt));
  }
  return out.join(",");
}`;
    const originalCtrTag = `export function Compile$ToBIRL$lower$apply$ctr_tag(
  st: Compile$ToBIRL$State,
  typ: Core$.Term | null,
  ctr_name: string,
): { tag: number, fields: string[] } {
  var fmt = Compile$ToBIRL$lower$apply$ctr_tag$format_line;
  var key = ctr_name;
  if (typ !== null) {
    var forced = Core$.Term$force(st.book, typ);
    if (forced !== null && forced.$ === "ADT") {
      var adt_key = Compile$ToBIRL$lower$apply$ctr_tag$adt_key(forced);
      key = adt_key + "/" + ctr_name;
    }
  }
  var fld_info = Compile$ToBIRL$ctr_flds(st.book, typ, ctr_name);
  var existing = st.ctr_tags.get(key);
  if (existing !== undefined) {
    // Merge field_shows: if a new instantiation disagrees on a field's
    // show kind (e.g. "u64" vs "adt"), downgrade to "auto" so the GC
    // traces the field conservatively.  Without this, the first
    // instantiation's shows win and later instantiations that swap
    // pointer/numeric field positions corrupt the GC f64-masks.
    if (fld_info !== null && existing._ctr_idx !== undefined) {
      var new_shows = fld_info.map(f => Compile$ToBIRL$lower$show_kind(st.book, f.typ));
      var old_shows: string[] = existing._field_shows ?? [];
      var changed = false;
      for (var si = 0; si < old_shows.length && si < new_shows.length; ++si) {
        if (old_shows[si] !== new_shows[si]) {
          old_shows[si] = "auto";
          changed = true;
        }
      }
      if (changed) {
        st.ctrs[existing._ctr_idx] = fmt(ctr_name, existing.tag, existing.fields, old_shows);
      }
    }
    return existing;
  }
  var tag = st.ctr_tag;
  st.ctr_tag += 1;
  var fields: string[] = [];
  var field_shows: string[] = [];
  if (fld_info !== null) {
    fields = fld_info.map(f => f.nam);
    field_shows = fld_info.map(f => Compile$ToBIRL$lower$show_kind(st.book, f.typ));
  }
  var info: any = { tag, fields, _ctr_idx: st.ctrs.length, _field_shows: field_shows };
  st.ctr_tags.set(key, info);
  st.ctrs.push(fmt(ctr_name, tag, fields, field_shows));
  return info;
}`;
    const originalCtrFlds = `export function Compile$ToBIRL$ctr_flds(
  book: Core$.Book | null,
  typ: Core$.Term | null,
  nam: string,
): Core$.Tele$Field[] | null {
  var adt = Core$.Term$force(book, typ);
  if (adt === null || adt.$ !== "ADT") {
    return null;
  }
  var [ctr] = Core$.Term$take_ctr(adt, nam);
  if (ctr === null) {
    return null;
  }
  return Core$.Tele$fields(ctr.fds);
}`;
    const originalShowKind = `export function Compile$ToBIRL$lower$show_kind(book: Core$.Book, typ: Core$.Term | null): string {
  var f = Core$.Term$force(book, typ);
  if (f === null) {
    return "auto";
  }
  if (f.$ === "Num") {
    return f.kind;
  }
  if (f.$ === "ADT") {
    var nat = Compile$ToBIRL$lower$native_type(book, f);
    if (nat === "char" || nat === "string") {
      return nat;
    }
    return "adt";
  }
  return "auto";
}`;
    const patchedNativeType = `export function Compile$ToBIRL$lower$native_type(
  book: Core$.Book | null,
  typ: Core$.Term | null,
): "char" | "string" | null {
  if (book === null) {
    return null;
  }
  try {
    var typ = Core$.Term$force(book, typ);
    if (typ === null || typ.$ !== "ADT") {
      return null;
    }
    // Check char: single constructor char{U32}
    if (Compile$ToBIRL$lower$native_type$is_char_adt(book, typ)) {
      return "char";
    }
    // Check string: nil{} + cons{Char, self} (not List(Char))
    if (typ.ctrs.length === 2) {
      var [nil_ctr] = Core$.Term$take_ctr(typ, "nil");
      var [cons_ctr] = Core$.Term$take_ctr(typ, "cons");
      var is_str_shape = nil_ctr !== null
        && Core$.Tele$fields(nil_ctr.fds).length === 0
        && cons_ctr !== null;
      if (is_str_shape) {
        var c_flds = Core$.Tele$fields(cons_ctr!.fds);
        if (c_flds.length === 2) {
          var hed = Core$.Term$force(book, c_flds[0].typ);
          var raw = Core$.Term$Peel(c_flds[1].typ, "reduced");
          if (hed !== null && hed.$ === "ADT" && Compile$ToBIRL$lower$native_type$is_char_adt(book, hed) && raw.$ !== "App") {
            return "string";
          }
        }
      }
    }
    return null;
  } catch (err) {
    if (err instanceof RangeError) {
      return null;
    }
    throw err;
  }
}`;
    const patchedAdtKey = `export function Compile$ToBIRL$lower$apply$ctr_tag$adt_key(adt: Core$.Term$ADT): string {
  var out: string[] = [];
  for (var ctr of adt.ctrs) {
    var cnt = 0;
    try {
      for (var _fld of Core$.Tele$fields(ctr.fds)) {
        cnt += 1;
      }
    } catch (err) {
      if (!(err instanceof RangeError)) {
        throw err;
      }
    }
    out.push(ctr.nam + "/" + String(cnt));
  }
  return out.join(",");
}`;
    const patchedCtrTag = `export function Compile$ToBIRL$lower$apply$ctr_tag(
  st: Compile$ToBIRL$State,
  typ: Core$.Term | null,
  ctr_name: string,
): { tag: number, fields: string[] } {
  var fmt = Compile$ToBIRL$lower$apply$ctr_tag$format_line;
  var key = ctr_name;
  if (typ !== null) {
    try {
      var forced = Core$.Term$force(st.book, typ);
      if (forced !== null && forced.$ === "ADT") {
        var adt_key = Compile$ToBIRL$lower$apply$ctr_tag$adt_key(forced);
        key = adt_key + "/" + ctr_name;
      }
    } catch (err) {
      if (!(err instanceof RangeError)) {
        throw err;
      }
    }
  }
  var fld_info = Compile$ToBIRL$ctr_flds(st.book, typ, ctr_name);
  var existing = st.ctr_tags.get(key);
  if (existing !== undefined) {
    // Merge field_shows: if a new instantiation disagrees on a field's
    // show kind (e.g. "u64" vs "adt"), downgrade to "auto" so the GC
    // traces the field conservatively.  Without this, the first
    // instantiation's shows win and later instantiations that swap
    // pointer/numeric field positions corrupt the GC f64-masks.
    if (fld_info !== null && existing._ctr_idx !== undefined) {
      var new_shows = fld_info.map(f => Compile$ToBIRL$lower$show_kind(st.book, f.typ));
      var old_shows: string[] = existing._field_shows ?? [];
      var changed = false;
      for (var si = 0; si < old_shows.length && si < new_shows.length; ++si) {
        if (old_shows[si] !== new_shows[si]) {
          old_shows[si] = "auto";
          changed = true;
        }
      }
      if (changed) {
        st.ctrs[existing._ctr_idx] = fmt(ctr_name, existing.tag, existing.fields, old_shows);
      }
    }
    return existing;
  }
  var tag = st.ctr_tag;
  st.ctr_tag += 1;
  var fields: string[] = [];
  var field_shows: string[] = [];
  if (fld_info !== null) {
    fields = fld_info.map(f => f.nam);
    field_shows = fld_info.map(f => Compile$ToBIRL$lower$show_kind(st.book, f.typ));
  }
  var info: any = { tag, fields, _ctr_idx: st.ctrs.length, _field_shows: field_shows };
  st.ctr_tags.set(key, info);
  st.ctrs.push(fmt(ctr_name, tag, fields, field_shows));
  return info;
}`;
    const patchedCtrFlds = `export function Compile$ToBIRL$ctr_flds(
  book: Core$.Book | null,
  typ: Core$.Term | null,
  nam: string,
): Core$.Tele$Field[] | null {
  let adt: Core$.Term | null = null;
  try {
    adt = Core$.Term$force(book, typ);
  } catch (err) {
    if (err instanceof RangeError) {
      return null;
    }
    throw err;
  }
  if (adt === null || adt.$ !== "ADT") {
    return null;
  }
  var [ctr] = Core$.Term$take_ctr(adt, nam);
  if (ctr === null) {
    return null;
  }
  try {
    return Core$.Tele$fields(ctr.fds);
  } catch (err) {
    if (err instanceof RangeError) {
      return null;
    }
    throw err;
  }
}`;
    const patchedShowKind = `export function Compile$ToBIRL$lower$show_kind(book: Core$.Book, typ: Core$.Term | null): string {
  let f: Core$.Term | null = null;
  try {
    f = Core$.Term$force(book, typ);
  } catch (err) {
    if (err instanceof RangeError) {
      return "auto";
    }
    throw err;
  }
  if (f === null) {
    return "auto";
  }
  if (f.$ === "Num") {
    return f.kind;
  }
  if (f.$ === "ADT") {
    var nat = Compile$ToBIRL$lower$native_type(book, f);
    if (nat === "char" || nat === "string") {
      return nat;
    }
    return "adt";
  }
  return "auto";
}`;
    const patchedFileId = `export function Loader$file_id(file: string, st: Loader$State): string | null {
  var base = Lib$path.basename(file);
  var in_prelude = file.startsWith(st.prelude_dir + Lib$path.sep);
  var root = in_prelude ? st.prelude_dir : st.root;
  if (base === "_.bend") {
    var seg = Lib$path.relative(root, Lib$path.dirname(file)).split(Lib$path.sep);
    if (seg.length === 0 || seg[0] === "") {
      return null;
    }
    if (in_prelude) {
      var top = seg[0];
      if (Loader$short_index$strip_root(seg) && seg.length >= 2) {
        return seg.slice(1).join("/");
      }
    }
    return seg.join("/");
  }
  if (!in_prelude && base.endsWith(".bend")) {
    var rel = Lib$path.relative(root, file);
    if (rel === "" || rel.startsWith("..")) {
      return null;
    }
    return rel.slice(0, -".bend".length).split(Lib$path.sep).join("/");
  }
  return null;
}`;
    const patchedNotePendingDefs = `export function Loader$note_pending_defs(defs: [string, Core$.Def][], fid: string | null, st: Loader$State): void {
  for (var [raw_nam] of defs) {
    st.pending.add(Loader$def_name(fid, raw_nam));
  }
}`;
    const patchedLoadImport = `export function Loader$load_import(
  imp: Parser$Import,
  file: string,
  als: Map<string, string>,
  st: Loader$State,
): void {
  var loc = Loader$resolve_file(imp.path, st);
  if (loc === null) {
    throw new Error("error: import not found '" + imp.path + "'\\n  imported from: " + file);
  }
  if (st.files.get(loc) !== false) {
    Loader$load_file(loc, st);
  }
  if (!st.book.has(imp.path)) {
    var found = st.pending.has(imp.path);
    var prefix = imp.path + "/";
    if (!found) {
      for (var key of st.pending) {
        if (key.startsWith(prefix)) {
          found = true;
          break;
        }
      }
    }
    for (var key of st.book.keys()) {
      if (key.startsWith(prefix)) {
        found = true;
        break;
      }
    }
    if (!found) {
      throw new Error("error: imported file does not define '" + imp.path + "'\\n  imported from: " + file);
    }
  }
  als.set(imp.alias, imp.path);
}`;

    await fs.rm(patchedRepoRoot, { recursive: true, force: true });
    await fs.mkdir(patchedRepoRoot, { recursive: true });
    await fs.cp(path.join(bendRepoRoot, "bend"), patchedBendRoot, { recursive: true });
    await fs.cp(path.join(bendRepoRoot, "birl"), patchedBirlRoot, { recursive: true });
    await fs.cp(path.join(bendRepoRoot, "base"), patchedBaseRoot, { recursive: true });

    const langSource = await fs.readFile(langPath, "utf8");
    if (!langSource.includes(originalResolveFile)) {
      throw new Error("Could not locate Bend Lang.Loader$resolve_file for patching");
    }
    if (!langSource.includes(originalFileId)) {
      throw new Error("Could not locate Bend Lang.Loader$file_id for patching");
    }
    if (!langSource.includes(originalNotePendingDefs)) {
      throw new Error("Could not locate Bend Lang.Loader$note_pending_defs for patching");
    }
    if (!langSource.includes(originalLoadImport)) {
      throw new Error("Could not locate Bend Lang.Loader$load_import for patching");
    }
    if (!langSource.includes(originalNativeType)) {
      throw new Error("Could not locate Bend Lang.Compile$ToBIRL$lower$native_type for patching");
    }
    if (!langSource.includes(originalAdtKey)) {
      throw new Error("Could not locate Bend Lang.Compile$ToBIRL$lower$apply$ctr_tag$adt_key for patching");
    }
    if (!langSource.includes(originalCtrTag)) {
      throw new Error("Could not locate Bend Lang.Compile$ToBIRL$lower$apply$ctr_tag for patching");
    }
    if (!langSource.includes(originalCtrFlds)) {
      throw new Error("Could not locate Bend Lang.Compile$ToBIRL$ctr_flds for patching");
    }
    if (!langSource.includes(originalShowKind)) {
      throw new Error("Could not locate Bend Lang.Compile$ToBIRL$lower$show_kind for patching");
    }
    await fs.writeFile(
      langPath,
      langSource
        .replace(originalResolveFile, patchedResolveFile)
        .replace(originalFileId, patchedFileId)
        .replace(originalNotePendingDefs, patchedNotePendingDefs)
        .replace(originalLoadImport, patchedLoadImport)
        .replace(originalNativeType, patchedNativeType)
        .replace(originalAdtKey, patchedAdtKey)
        .replace(originalCtrTag, patchedCtrTag)
        .replace(originalCtrFlds, patchedCtrFlds)
        .replace(originalShowKind, patchedShowKind)
    );

    return import(`${pathToFileURL(path.join(patchedBendRoot, "src", "Bend.ts")).href}?ts=${Date.now()}`);
  }

  const bendSrcDir = layout.bendSrcDir;
  const patchedRoot = path.resolve(process.env.TMPDIR ?? "/tmp", `dungeonbend-bend-ts-src-${process.pid}`);
  const typeAnalysisPath = path.join(patchedRoot, "Compile/ToJS/TypeAnalysis.ts");
  const compilerPath = path.join(patchedRoot, "Compile/ToJS/Compiler.ts");
  const originalForceType = `export function force_type(book: Core.Book, typ: Core.Term | null): Core.Term | null {
  if (typ === null) {
    return null;
  }
  return Core.wnf_force(book, typ);
}`;
  const patchedForceType = `export function force_type(book: Core.Book, typ: Core.Term | null): Core.Term | null {
  if (typ === null) {
    return null;
  }
  try {
    return Core.wnf_force(book, typ);
  } catch (err) {
    if (err instanceof RangeError) {
      return null;
    }
    throw err;
  }
}`;
  const originalNativeType = `export function native_type(book: Core.Book | null, typ: Core.Term | null): "char" | "string" | "vector" | null {
  if (book === null) {
    return null;
  }
  var typ = force_type(book, typ);
  if (typ === null || typ.$ !== "ADT") {
    return null;
  }
  if (adt_is_char(book, typ)) {
    return "char";
  }
  if (adt_is_string(book, typ)) {
    return "string";
  }
  if (adt_is_vector(book, typ)) {
    return "vector";
  }
  return null;
}`;
  const originalCtrFlds = `export function ctr_flds(
  book: Core.Book | null,
  typ: Core.Term | null,
  nam: string,
): Core.TeleFld[] | null {
  if (book === null) {
    return null;
  }
  var adt = force_type(book, typ);
  if (adt === null || adt.$ !== "ADT") {
    return null;
  }
  var [ctr] = Core.take_constructor(adt, nam);
  if (ctr === null) {
    return null;
  }
  return Core.tele_flds(ctr.fds);
}`;
  const patchedCtrFlds = `export function ctr_flds(
  book: Core.Book | null,
  typ: Core.Term | null,
  nam: string,
): Core.TeleFld[] | null {
  if (book === null) {
    return null;
  }
  let adt: Core.Term | null = null;
  try {
    adt = force_type(book, typ);
  } catch (err) {
    if (err instanceof RangeError) {
      return null;
    }
    throw err;
  }
  if (adt === null || adt.$ !== "ADT") {
    return null;
  }
  var [ctr] = Core.take_constructor(adt, nam);
  if (ctr === null) {
    return null;
  }
  try {
    return Core.tele_flds(ctr.fds);
  } catch (err) {
    if (err instanceof RangeError) {
      return null;
    }
    throw err;
  }
}`;
  const patchedEmitStringCtr = `function emit_string_ctr(st: Types.EmitState, dst: string, trm: Core.Ctr, ctx: Types.EmitCtx): void {
  function unwrap(tm: Core.Term): Core.Term {
    while (tm.$ === "Ann" || tm.$ === "Red") {
      tm = tm.$ === "Ann" ? tm.val : tm.rgt;
    }
    return tm;
  }
  var cur: Core.Term = trm;
  var out = "";
  while (true) {
    cur = unwrap(cur);
    if (cur.$ !== "Ctr") {
      break;
    }
    if (cur.nam === "nil") {
      Emit.emit_set(st, dst, JSON.stringify(out));
      return;
    }
    if (cur.nam !== "cons" || cur.fds.length !== 2) {
      break;
    }
    var hed_tm = unwrap(cur.fds[0]);
    if (hed_tm.$ !== "Ctr" || hed_tm.nam !== "char" || hed_tm.fds.length !== 1) {
      break;
    }
    var chr_tm = unwrap(hed_tm.fds[0]);
    if (chr_tm.$ !== "W32") {
      break;
    }
    out += String.fromCharCode((chr_tm.val >>> 0) & 0xFFFF);
    cur = cur.fds[1];
  }
  if (trm.nam === "nil") {
    Emit.emit_set(st, dst, '""');
    return;
  }
  var hed = emit_sub(st, trm.fds[0], ctx);
  var rst = emit_sub(st, trm.fds[1], ctx);
  Emit.emit_set(st, dst, "(" + hed + " + " + rst + ")");
}`;
  const emitStringCtrPattern = /function emit_string_ctr\(st: Types\.EmitState, dst: string, trm: Core\.Ctr, ctx: Types\.EmitCtx\): void \{[\s\S]*?\n\}/;
  const patchedNativeType = `export function native_type(book: Core.Book | null, typ: Core.Term | null): "char" | "string" | "vector" | null {
  if (book === null) {
    return null;
  }
  try {
    var typ = force_type(book, typ);
  } catch (err) {
    if (err instanceof RangeError) {
      return null;
    }
    throw err;
  }
  if (typ === null || typ.$ !== "ADT") {
    return null;
  }
  try {
    if (adt_is_char(book, typ)) {
      return "char";
    }
    if (adt_is_string(book, typ)) {
      return "string";
    }
    if (adt_is_vector(book, typ)) {
      return "vector";
    }
  } catch (err) {
    if (err instanceof RangeError) {
      return null;
    }
    throw err;
  }
  return null;
}`;

  await fs.rm(patchedRoot, { recursive: true, force: true });
  await fs.cp(bendSrcDir, patchedRoot, { recursive: true });

  const typeAnalysisSource = await fs.readFile(typeAnalysisPath, "utf8");
  const compilerSource = await fs.readFile(compilerPath, "utf8");
  if (!typeAnalysisSource.includes(originalForceType)) {
    throw new Error("Could not locate Bend TypeAnalysis.force_type for patching");
  }
  if (!typeAnalysisSource.includes(originalNativeType)) {
    throw new Error("Could not locate Bend TypeAnalysis.native_type for patching");
  }
  if (!typeAnalysisSource.includes(originalCtrFlds)) {
    throw new Error("Could not locate Bend TypeAnalysis.ctr_flds for patching");
  }
  if (!emitStringCtrPattern.test(compilerSource)) {
    throw new Error("Could not locate Bend Compiler.emit_string_ctr for patching");
  }
  await fs.writeFile(
    typeAnalysisPath,
    typeAnalysisSource
      .replace(originalForceType, patchedForceType)
      .replace(originalNativeType, patchedNativeType)
      .replace(originalCtrFlds, patchedCtrFlds)
  );
  await fs.writeFile(compilerPath, compilerSource.replace(emitStringCtrPattern, patchedEmitStringCtr));

  return import(`${pathToFileURL(path.join(patchedRoot, "Bend.ts")).href}?ts=${Date.now()}`);
}

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
  // Bend's JS backend sometimes emits discard bindings such as `var #_$5 = x$4;`
  // which are invalid identifiers in JS and crash the app before first render.
  out = out.replace(/#_\$(\d+)/g, (_match, suffix) => `_discard_$${suffix}`);
  if (out.includes(childPatchBuggy)) {
    out = out.replace(childPatchBuggy, childPatchFixed);
  }
  if (out.includes(replaceBuggy)) {
    out = out.replace(replaceBuggy, replaceFixed);
  }
  if (out.includes(stepBuggy)) {
    out = out.replace(stepBuggy, stepFixed);
  }
  // Inject a global keydown listener so arrow keys work without clicking the
  // board first.  The listener finds the .page element and, if it is not
  // already the event target, re-dispatches the key event on it.
  const globalKeyPatch = [
    "document.addEventListener(\"keydown\", function(e) {",
    "  var page = document.querySelector(\".page\");",
    "  if (page && e.target !== page) {",
    "    page.dispatchEvent(new KeyboardEvent(\"keydown\", {",
    "      key: e.key, code: e.code, keyCode: e.keyCode,",
    "      bubbles: false, cancelable: true",
    "    }));",
    "    e.preventDefault();",
    "  }",
    "});",
  ].join("\n");

  out = out.replace("</script>", globalKeyPatch + "\n</script>");

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
const bendLayout = await resolveLocalBendLayout(cwd);

await generateDungeonData(cwd);
const Bend = await loadPatchedBend(bendLayout);

const html = bendLayout.kind === "current"
  ? (() => {
      const loaded = Bend.Lang.Loader$load_book(file);
      return patchAppRuntime(Bend.Lang.Compile$ToBIRL$page(loaded.book, {
        main_name: loaded.main,
        title: path.basename(file, ".bend"),
      }));
    })()
  : (() => {
      const loaded = Bend.Loader.load_book(file, {
        prelude_dir: process.env.BEND_PRELUDE_DIR
          ? path.resolve(cwd, process.env.BEND_PRELUDE_DIR)
          : bendLayout.preludeDir,
        strict: true,
      });
      const ok = Bend.Core.check_book(loaded.book, {
        show_ok: false,
        write: process.stderr.write.bind(process.stderr),
      });

      if (!ok) {
        process.exit(1);
      }

      return patchAppRuntime(Bend.ToJS.page(loaded.book, {
        main_name: loaded.main,
        title: path.basename(file, ".bend"),
      }));
    })();

await Bun.write(out, html);
