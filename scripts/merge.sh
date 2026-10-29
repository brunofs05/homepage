#!/usr/bin/env bash
set -euo pipefail

# merge.sh — compila o .typ de uma página e injeta o resultado no esqueleto HTML (bone)
#
# Uso:
#   bash scripts/merge.sh                → processa todas as páginas das seções (SECTIONS)
#   bash scripts/merge.sh projects/egpu  → processa apenas a página especificada
#
# Cada página é um .typ dentro de uma seção, e o .html sai ao lado dele:
#   courses/timeseries.typ → courses/timeseries.html
# Os .html gerados não vão para o git (veja o .gitignore).
#
# O título da página é lido da primeira linha do .typ:
#   // title: Deep Learning
#
# O bone (esqueleto HTML, função bone() abaixo) tem dois placeholders:
#   {{TITLE}}          → substituído pelo título acima
#   <!-- CONTENT:START --> ... <!-- CONTENT:END --> → substituído pelo <body> do typst

# Pastas que contêm páginas em typst. Seção nova: acrescentar aqui e no
# scripts/deploy-filter.txt.
SECTIONS=(courses projects)

# Saídas intermediárias do typst ficam fora do repositório, numa pasta temporária
# que o trap apaga quando o script termina, com sucesso ou com erro.
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

# bone — esqueleto compartilhado por todas as páginas geradas.
# Os caminhos ../ existem porque a saída fica um nível abaixo da raiz (<seção>/).
bone() {
  cat <<'BONE_EOF'
<!DOCTYPE html>

<html lang="pt-BR" data-theme="">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="color-scheme" content="light dark">
  <title>{{TITLE}}</title>
  <link rel="stylesheet" href="../css/styles.css">
  <script src="../js/theme.js" defer></script>
</head>

<body>
  <header>
    <h1>Bruno Ferreira</h1>
  </header>

  <main class="reading-main">

    <section class="like-tui reading">
      <h2>{{TITLE}}</h2>
      <div class="note-content">
        <!-- CONTENT:START -->
        <!-- CONTENT:END -->
      </div>
    </section>

  </main>

</body>

</html>
BONE_EOF
}

# merge_page <seção>/<página>   ex: merge_page projects/egpu
merge_page() {
  local page="$1"
  local typ="$page.typ"
  local out="$page.html"

  [ -f "$typ" ] || { echo "não achei $typ"; return 1; }

  # Lê o título da primeira linha do .typ: "// title: Deep Learning"
  local title
  title="$(head -1 "$typ" | sed 's|^// title:[[:space:]]*||')"

  [ -n "$title" ] || { echo "⚠ título não encontrado em $typ (esperado: // title: ...)"; return 1; }

  local tmp="$TMP_DIR/${page//\//-}.html"

  # --root . → a raiz do repositório é a raiz do typst: caminhos começando com /
  # (ex: #import "/typst/_utils.typ") valem a partir dela, em qualquer seção.
  typst compile "$typ" "$tmp" --features html --format html --root .

  BONE="$(bone)" python3 - "$tmp" "$out" "$title" <<'PYEOF'
import os, re, sys
tmp, out, title = sys.argv[1:4]

typst_html = open(tmp, encoding="utf-8").read()
m = re.search(r"<body[^>]*>(.*)</body>", typst_html, re.S)
content = (m.group(1) if m else typst_html).strip()

skeleton = os.environ["BONE"]

# Injeta o título nos dois placeholders {{TITLE}}
skeleton = skeleton.replace("{{TITLE}}", title)

# Injeta o conteúdo compilado entre os marcadores
start, end = "<!-- CONTENT:START -->", "<!-- CONTENT:END -->"
pattern = re.compile(re.escape(start) + r".*?" + re.escape(end), re.S)

if not pattern.search(skeleton):
    sys.exit("marcadores CONTENT:START/END não encontrados no bone")

merged = pattern.sub(f"{start}\n{content}\n{end}", skeleton)
open(out, "w", encoding="utf-8").write(merged)
PYEOF

  echo "gerado: $out"
}

if [ $# -gt 0 ]; then
  # Página específica: aceita "projects/egpu" ou "projects/egpu.typ"
  merge_page "${1%.typ}"
else
  for section in "${SECTIONS[@]}"; do
    [ -d "$section" ] || { echo "pasta '$section' não encontrada"; exit 1; }
    for typ in "$section"/*.typ; do
      [ -f "$typ" ] || continue
      echo "→ processando: ${typ%.typ}"
      merge_page "${typ%.typ}" || { echo "⚠ erro ao processar: $typ"; exit 1; }
    done
  done
fi
