#!/usr/bin/env bash
set -euo pipefail

# merge.sh — compila anotations.typ de um curso e injeta o resultado no bone.html
#
# Uso:
#   bash scripts/merge.sh             → processa todos os cursos em courses/
#   bash scripts/merge.sh deeplearning → processa apenas o curso especificado
#
# O título da página é lido da primeira linha do .typ:
#   // title: Deep Learning
#
# O bone único (courses/bone.html) tem dois placeholders:
#   {{TITLE}}          → substituído pelo título acima
#   <!-- CONTENT:START --> ... <!-- CONTENT:END --> → substituído pelo <body> do typst

BONE="courses/bone.html"

merge_course() {
  local course="$1"
  local typ="courses/$course.typ"
  local out="courses/index/$course.html"
  local tmp="courses/index/.$course-typst-out.html"

  [ -f "$typ" ]    || { echo "não achei $typ";    return 1; }
  [ -f "$BONE" ]   || { echo "não achei $BONE";   return 1; }

  # Lê o título da primeira linha do .typ: "// title: Deep Learning"
  local title
  title="$(head -1 "$typ" | sed 's|^// title:[[:space:]]*||')"

  [ -n "$title" ] || { echo "⚠ título não encontrado em $typ (esperado: // title: ...)"; return 1; }

  typst compile "$typ" "$tmp" --features html --root courses/

  python3 - "$tmp" "$BONE" "$out" "$title" <<'PYEOF'
import re, sys
tmp, bone, out, title = sys.argv[1:5]

typst_html = open(tmp, encoding="utf-8").read()
m = re.search(r"<body[^>]*>(.*)</body>", typst_html, re.S)
content = (m.group(1) if m else typst_html).strip()

skeleton = open(bone, encoding="utf-8").read()

# Injeta o título nos dois placeholders {{TITLE}}
skeleton = skeleton.replace("{{TITLE}}", title)

# Injeta o conteúdo compilado entre os marcadores
start, end = "<!-- CONTENT:START -->", "<!-- CONTENT:END -->"
pattern = re.compile(re.escape(start) + r".*?" + re.escape(end), re.S)

if not pattern.search(skeleton):
    sys.exit(f"marcadores CONTENT:START/END não encontrados em {bone}")

merged = pattern.sub(f"{start}\n{content}\n{end}", skeleton)
open(out, "w", encoding="utf-8").write(merged)
PYEOF

  rm -f "$tmp"
  echo "gerado: $out"
}

if [ $# -gt 0 ]; then
  # Curso específico passado como argumento
  merge_course "$1"
else
  # Processa todos os cursos dentro de courses/ (ignora _utils.typ)
  [ -d "courses" ] || { echo "pasta 'courses' não encontrada"; exit 1; }
  for typ in courses/*.typ; do
    [ -f "$typ" ] || continue
    course="$(basename "$typ" .typ)"
    [ "$course" = "_utils" ] && continue
    echo "→ processando: $course"
    merge_course "$course" || echo "⚠ erro ao processar: $course"
  done
fi
