// _utils.typ — funções compartilhadas entre todos os cursos
// Importar com: #import "../_utils.typ": collapsible

// collapsible(summary: [...], open: false)[...corpo...]
//
// Gera um <details><summary> no HTML.
// - summary: o texto do cabeçalho clicável
// - open:    true  → começa expandido  (<details open>)
//            false → começa fechado    (<details>)      ← padrão
// - corpo:   qualquer conteúdo Typst entre os colchetes [ ]
//
// No PDF (caso você compile sem --features html) vira
// um bloco com borda simples como fallback.

#let collapsible(summary: [], open: false, body) = context {
  if target() == "html" {
    let attrs = if open { (open: "") } else { (:) }
    html.elem("details", attrs: attrs)[
      #html.elem("summary")[#summary]
      #body
    ]
  } else {
    // fallback PDF
    block(stroke: 0.5pt + gray, inset: 8pt, radius: 3pt)[
      *#summary*
      #v(0.5em)
      #body
    ]
  }
}

// divider()
//
// Separador horizontal — substitui #line(length: 100%) nos .typ.
// No HTML vira um <hr>; no PDF mantém o line original.

#let divider() = context {
  if target() == "html" {
    html.elem("hr")
  } else {
    line(length: 100%)
  }
}
