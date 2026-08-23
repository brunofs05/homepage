#!/usr/bin/env bash
set -euo pipefail

course="$1"                       
dir="courses/$course"
typ="$dir/anotations.typ"
bone="$dir/bone.html"
out="$dir/index.html"
tmp="$dir/.typst-out.html"

[ -f "$typ" ]  || { echo "não achei $typ"; exit 1; }
[ -f "$bone" ] || { echo "não achei $bone"; exit 1; }

typst compile "$typ" "$tmp" --features html

python3 - "$tmp" "$bone" "$out" <<'PYEOF'
import re, sys
tmp, bone, out = sys.argv[1:4]

typst_html = open(tmp, encoding="utf-8").read()
m = re.search(r"<body[^>]*>(.*)</body>", typst_html, re.S)
content = (m.group(1) if m else typst_html).strip()

skeleton = open(bone, encoding="utf-8").read()
start, end = "<!-- CONTENT:START -->", "<!-- CONTENT:END -->"
pattern = re.compile(re.escape(start) + r".*?" + re.escape(end), re.S)

if not pattern.search(skeleton):
    sys.exit(f"marcadores não encontrados em {bone}")

merged = pattern.sub(f"{start}\n{content}\n{end}", skeleton)
open(out, "w", encoding="utf-8").write(merged)
PYEOF

rm -f "$tmp"
echo "gerado: $out"
