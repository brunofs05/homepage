// title: Natural Language Processing
#import "_utils.typ": collapsible, divider

Notes:
These are personal class notes, not necessarily cohesive, not necessarily structured, and — most importantly — not necessarily accurate! Please check the sources, and feel free to point out any errors via email!

#divider()

#collapsible(summary: "1. O estudo formal da língua natural", open: false)[

== 1.1 O estudo da língua natural
- Gramática := pode ser enunciada como: descrições explícitas das regras implícitas que os falantes dominam sem saber enunciar, existe em várias camadas: fonologia, morfologia: formação de palavras, sintaxe: combinação em sentenças, semântica: significado das expressões. Vamos tratar principalmente de sintaxe e semântica
- A linguística é o estudo científico da língua humana. Chomsky (1957) propôs identificar uma língua com o conjunto de todas sentenças gramaticais dessa língua, separando a competência: capacidade de reconhecer sentenças válidas do desempenho: fazer o uso efetivo.

Uma boa gramática deve:
1) gerar expressões bem formadas da língua
2) determinar a estrutura interna das expressÕes
3) permitir a atribuição de significado as estruturas

== 1.2 Sintaxe, semântica e pragmática
Outras definições (ou reorganizando palavras):
- Sintaxe: estudo das cadeias e da estrutura imposta pela gramática
- Semântica: estudo da relação entre cadeias e seus significados
- Pragmática: estudo do uso comunicativo das cadeias significativas

"Tipos de Linguagem" -> Uma linguagem natural é essencialmente julgada pelos seus falantes nativos, enquanto uma linguagem formal possui suas definições de certo e errado.

Trazendo outros termos ao nosso entendimento, saber "que" e "como":
- Significado operacional := saber como executar/seguir instruções 
- Significado denotacional := saber que expressão descreve o mundo

== 1.3 Os propósitos da comunicação
A língua desempenha muitos papéis na realidade, o foco deste curso será descrição de estados de coisas e de raciocínio

== 1.4 Línguas naturais e línguas formais
Três traços de design cruciais das línguas humanas que as diferenciam de sistemas animais, como a dança das abelhas:

- Dupla articulação: dois níveis estruturais — unidades significativas (morfemas/palavras) feitas de unidades não significativas (fonemas), que apenas diferenciam significados
- Recursão: padrões estruturais podem se repetir indefinidamente
- Contextualidade: o significado depende em parte do contexto de uso

Essas propriedades permitem construir/entender infinitas sentenças a partir de recursos finitos (sons e regras) — condição para a aprendizagem rápida da língua pelas crianças.

- Composicionalidade (princípio atribuído a Frege): o significado de uma expressão complexa depende dos significados das partes e de como são combinadas sintaticamente. É tratada como questão metodológica, não como traço definidor das línguas naturais, a pergunta é se queremos projetar a semântica de forma composicional. Exige sistematicidade
- Dificuldades recorrentes à composicionalidade: pronomes e pressuposições, que dependem de contexto
- Linguagens formais compartilham algumas propriedades das línguas naturais, mas carecem da dimensão pragmática (engano, ironia, metáfora) e da flexibilidade ligada à vagueza e ao conhecimento de fundo, por isso línguas naturais são melhores para comunicação humana, e linguagens formais para matemática/computação
- Em termos computacionais: a interpretação é uma função recursiva sobre a estrutura sintática — cada construção gramatical tem um caso, combinando os resultados dos "filhos"

== 1.5 O que a semântica formal não é
Existe uma dificuldade, explicar coisas como o que é uma bicicleta a desenhando, estamos associando dois símbolos um ao outro, a palavra ao desenho, dificuldade de explicar significado sem referência de símbolos

== 1.6 Semântica computacional e programação funcional
Baseada no cálculo lambda tipado, mais em breve

- Programação funcional é útil a linguistas porque força precisão total nas regras propostas e dá retorno imediato sobre teorias linguísticas.
- Dois usos principais de máquinas em semântica computacional: 1) automatizar a construção de representações de significado; 2) operar sobre os resultados (verificação/construção de modelos, inferência), essenciais para PLN
- O livro usa Lean (em vez da tradição em Prolog), pois Prolog precisa de operadores de controle (assert, retract, cut) que comprometem a pureza lógica e dificultam entender/depurar programas. Já a programação funcional permite implementações fiéis às definições formais, com base lógica sólida que facilita verificar a correção da teoria semântica

]

#collapsible(summary: "2. Programação Funcional no Lean", open: false)[

== 2.1 Termos e Tipos
- Termo := expressão sintaticamente válida que representa um objeto e possui um tipo
- Tipos funcionam como conjuntos mas não são conjuntos, servem pra classificar termos e impor disciplina (`1 ∈ 2` no papel vs erro de tipagem em Lean)
- Tipos básicos: `ℕ`, `ℤ`, `ℚ`, `Bool`. `σ → τ` := tipo das funções de σ em τ
- Ordem superior := tipo com `→` aninhada à esquerda de outra `→`, ex `(ℤ → ℤ) → ℚ`
- `#eval` calcula, `#check` só confirma/pergunta o tipo sem computar
- `def nome : Tipo := valor` introduz nome no ambiente, tipo às vezes inferido
- Tipos também são termos e têm tipo (`Bool : Type`, `Type : Type 1`...), hierarquia de universos existe pra evitar paradoxo de "tipo de todos os tipos"

== 2.2 Funções
- `fun x => x * x` / `λ x ↦ x * x` são a mesma coisa, unicode é aceito
- Nome do parâmetro não importa pra identidade da função (provável com `rfl`)
- `opaque` := declara tipo/constante/função sem dar implementação
- `example` sem nome, `theorem` com nome pra poder referenciar depois. `rfl` fecha igualdade quando os dois lados computam o mesmo valor
- `+`, `*` são açúcar sintático pra funções via classes (`Nat.add` etc), isso é o que dá o polimorfismo
- Tipo não resolvido vira metavariável (`?m.7`), um buraco esperando contexto ou anotação pra decidir
- Funções são de primeira classe: podem ser passadas como argumento (ordem superior) e também retornadas (currying/avaliação parcial)

== 2.3 Expressões
- Toda expressão é termo. Termo canônico := já está na forma final, não reduz mais
- `let` nomeia valor dentro de uma expressão, expressão toda tem valor
- `if-then-else` é expressão, não comando — por isso os dois ramos precisam ter mesmo tipo

== 2.4 Estruturas
- `structure` agrupa valores nomeados, cria tipo novo + namespace, gera construtor (`Point.mk`) e projeção por campo (`Point.x`)
- `⟨_, _⟩` := construtor anônimo, usado quando o tipo esperado já deixa claro qual construtor usar, serve também pra desmontar argumento
- `{ p with x := ... }` := cópia da estrutura alterando só alguns campos, útil quando tem muito campo

== 2.5 Tipos Indutivos
- `inductive` lista as formas que os valores do tipo podem ter — construção mais importante do curso, uma BNF é literalmente um `inductive`
- Sem argumento → enumeração (`Day`). Com argumento → registro variante. Forma referindo o próprio tipo → recursivo/árvore (`Nat`)
- `deriving Repr, DecidableEq` gera exibição e igualdade automaticamente

== 2.6 Recursão
- Definição recursiva precisa de caso base + garantia (verificada pelo compilador) de que chega nele
- Em `Nat`, casar `0` / `n + 1` já dá as duas coisas de graça (chamada recursiva sobre algo estritamente menor)
- `factorial` (casando padrão) vs `factorial'` (com `if`, `x - 1` como decréscimo que precisa ser verificado, não vem de graça da forma)
- Casamento de padrão é açúcar pra `match` por baixo
- `IO.println <| expr` pra interpretar `\n` e afins, `#eval` sozinho não interpreta

== 2.7 Listas e Polimorfismo
- `List α` é indutivo: `[]` ou `x :: xs` — por isso recursão sobre lista tem a mesma forma que recursão sobre `Nat`
- `α` é parâmetro de tipo, `List Nat ≠ List String` mesmo sendo gerados pelo mesmo `List`
- `{α : Type}` entre chaves := parâmetro implícito, Lean infere sozinho

== 2.8 O tipo Option
- `List α → α` promete elemento sempre, impossível pra lista vazia
- `List α → Option α` corrige no tipo: `some x` ou `none`, obriga quem chama a tratar os dois casos
- Alternativa: função devolve valor default do tipo (ex `String.back` de string vazia)

== 2.9 Processamento de Listas
- `List.map` aplica função a cada elemento
- `List.filter` mantém só quem satisfaz condição
- `List.foldl` / `List.foldr` reduzem lista a valor final
- `List.all` / `List.any` := todos / algum satisfaz condição, devolve `Bool`

== 2.10 Composição de Funções
- `f ∘ g` := aplica g depois f, `(f ∘ g) x = f (g x)`

== 2.11 Classes de Tipos
- Função genérica sobre α pode exigir capacidade via classe entre colchetes, ex `[BEq α]` pra poder usar `==`
- `deriving instance BEq for Day` gera automático, mas igualdade não trivial (ex `Angle`, -90° = 270°) precisa de instância manual
- `BEq α` devolve `Bool` (`==`) vs `DecidableEq α` devolve prova de igualdade/desigualdade (usável em `if` e em demonstração)
- `Repr` := como representar texto de um tipo, produz `Std.Format` (não `String` direto), formato intermediário que permite pretty printing (indentação/quebra configurável, ideia de Wadler). Separa estrutura do dado da apresentação — dá pra customizar sem mexer na definição do tipo

== 2.12 Cadeias de Texto
- `String` é UTF-8 empacotada, não lista de char — não dá pra casar padrão direto (`c :: cs` não funciona)
- Solução: converter `String ↔ List Char` (`.toList` / `String.ofList`) pra processar recursivamente

== 2.13 Lean e o Cálculo Lambda
- LC tem 3 formas (BNF): variável, aplicação `(E E)`, abstração `(λ v ↦ E)` — essa gramática vira tipo indutivo direto (`Lam`), cada cláusula BNF = um construtor. Isso é o motor do curso: gramática = tipo indutivo, "bem formado" = "bem tipado"
- Lean é baseado no CiC (Cálculo de Construtores Indutivos), extensão tipada do LC
- β-redução := aplicar abstração a argumento substitui parâmetro pelo valor no corpo. `#eval` executa, `rfl` verifica
- Substituição não é trivial (risco de captura de variável), mas Lean trata certo por baixo dos panos
- Nem toda redução termina: ω = `(λx ↦ x x) (λx ↦ x x)` entra em loop — e nem dá pra escrever em Lean, porque exigiria x com tipo `?m → ?n` e `?m` ao mesmo tempo, impossível de tipar
- No cálculo lambda tipado (base de Lean): todo termo bem tipado tem forma normal, toda redução termina — por isso Lean é linguagem de programação E lógica consistente ao mesmo tempo (terminação garantida pelos tipos). Às vezes Lean não prova sozinho que uma função termina, aí a prova de terminação é trabalho meu
- Além de tipos simples/indutivos: tipos dependentes (tipo depende de valor, ex `Vector`), proposições como tipos (`Prop`), universos de tipos (`Type`, `Type 1`...) pra evitar paradoxo

]

#collapsible(summary: "4. Conjuntos e Relações", open: false)[

== 4.1 Conjuntos e notação de conjuntos
- Conjunto := função característica de um elemento, duas formas de responder pertinência: `α → Bool` (calcula, roda) ou `α → Prop` (enuncia, prova) — é essa segunda que Lean usa: `Set α := α → Prop`
- `x ∈ A` é só açúcar pra `A x`, e o desdobramento entre os dois é `rfl` (não pede justificativa) — útil pra destravar prova empacada
- `decide` não desdobra `def`, então em conjunto definido via `def` precisa `unfold` antes de `decide` conseguir calcular
- `∅ := fun _ ↦ False`, `Set.univ := fun _ ↦ True`
- União/interseção são disjunção/conjunção elemento a elemento
- `Even n` (enuncia, ∃r, n = r+r) vs `isEven n` (calcula, `n % 2 == 0`) := mesma dicotomia calcular/enunciar de conjuntos. Mathlib prova que coincidem (`Nat.even_iff`), e uma vez provado isso `Even n` também fica calculável via `#eval` — mecanismo por trás disso é a classe `Decidable` (mesma família de `BEq`/`DecidableEq`)

== 4.2 Relações
- `Rel α β := α → β → Prop` — mesma ideia de conjunto, mas pra pares
- Inversa (`flip R`) troca a ordem dos argumentos — em língua é o que a voz passiva faz
- Composição (`Relation.Comp R S`) encadeia por elemento intermediário: `x` relaciona a `z` se existe `y` com `x R y` e `y S z` — provar composição é exibir esse `y`. É o que dá "avô" = "pai" ∘ "pai"
- Reflexividade/simetria/transitividade são afirmações sobre a relação inteira (quantificador + conectivo), as três juntas dão `Equivalence`
- Divisibilidade (`∣`) é outro exemplo enuncia-mas-calcula: existe instância `Decidable` por trás

== 4.3 Funções
- Função é caso particular de relação: pra cada `a`, no máximo um `b` relacionado — é essa unicidade que permite escrever `f x` em vez de "algum b tal que..."
- Toda relação (como conjunto de pares) tem função característica — `likesR` já É a função característica da relação de gostar

]

#collapsible(summary: "Exercícios do livro", open: false)[ 

=== 1.X.1 possibilities
```lean
-- Cada fato básico duplica o número de possibilidades:
-- com 0 fatos, só existe 1 "cenário" (o vazio);
-- a cada fato adicional, cada cenário anterior se desdobra em dois
-- (o fato sendo verdadeiro ou falso).
def possibilities : Nat → Nat
  | 0 => 1
  | n + 1 => 2 * possibilities n

#eval possibilities 10  -- com 10 fatos básicos: 1024 possibilidades
-- caso geral: possibilities n = 2 ^ n

-- Prova de que a função realmente computa 2 ^ n
example (n : Nat) : possibilities n = 2 ^ n := by
  induction n with
  | zero =>
    -- possibilities 0 = 1 = 2 ^ 0, ambos os lados reduzem por definição
    rfl
  | succ k ih =>
    -- ih : possibilities k = 2 ^ k (hipótese de indução)
    -- objetivo: possibilities (k+1) = 2 ^ (k+1)
    -- desdobra possibilities (k+1) em 2 * possibilities k,
    -- substitui pela hipótese de indução, e reagrupa a potência
    rw [possibilities, ih, Nat.pow_succ']
``` 

== 1.X.2 sentence-go-on
```lean
-- O ponto final não pode fazer parte do padrão que se repete,
-- senão ele apareceria no meio da frase. Por isso separamos:
-- andOn n = as n repetições de " and on", sem mais nada.
def andOn : Nat → String
  | 0 => ""
  | n + 1 => " and on" ++ andOn n

-- sentence n = início fixo + repetições + ponto final
def sentence (n : Nat) : String :=
  "Sentences can go on" ++ andOn n ++ "."

#eval sentence 0  -- "Sentences can go on."
#eval sentence 1  -- "Sentences can go on and on."
#eval sentence 2  -- "Sentences can go on and on and on."
#eval sentence 3  -- "Sentences can go on and on and on and on."
```

== 2.X.1 sum-of-squares
```lean
-- soma de quadrados: m² + n², reta pura aplicação da definição
def sumOfSquares (m n : Nat) : Nat :=
  m * m + n * n

example : sumOfSquares 3 4 = 25 := rfl
```

== 2.X.2 is-weekend
```lean
-- Day é enumeração, então basta casar os dois casos que interessam
-- e cobrir o resto com `_`
def isWeekend (d : Day) : Bool :=
  match d with
  | .saturday => true
  | .sunday   => true
  | _         => false
```

== 2.X.3 sum-to
```lean
-- mesma forma de recursão do factorial: caso base 0, e o passo
-- soma (n+1) ao resultado da chamada recursiva com n (estritamente menor)
def sumTo : Nat → Nat
  | 0     => 0
  | n + 1 => (n + 1) + sumTo n

-- 0+1+2+3+4 = 10, confere por rfl (reduz direto pois 4 é literal)
theorem sumTo_test : sumTo 4 = 10 := rfl
```

== 2.X.4 sum-list
```lean
-- recursão sobre List tem a mesma cara da recursão sobre Nat:
-- caso base [] e o passo processa a cabeça, recursa na cauda
def sumList (ns : List Nat) : Nat :=
  match ns with
  | []      => 0
  | x :: xs => x + sumList xs

theorem sumList_test : sumList [1, 2, 3, 4] = 10 := rfl
```

== 2.X.5 count-zeros
```lean
-- igual sumList, mas em vez de acumular o valor, só conta
-- quando a cabeça é 0
def countZeros (ns : List Nat) : Nat :=
  match ns with
  | []      => 0
  | 0 :: xs => 1 + countZeros xs
  | _ :: xs => countZeros xs

theorem countZeros_test : countZeros [0, 1, 0, 2, 0] = 3 := rfl
```

== 4.X.1 five-in-above2 / one-not-in-above2 / above5-subset-above2
```lean
-- 5 ∈ above2 é só 5 > 2, decide resolve depois de desdobrar o def
example : 5 ∈ above2 := by
  unfold above2
  decide

-- 1 ∉ above2 é ¬(1 > 2), mesma ideia
example : 1 ∉ above2 := by
  unfold above2
  decide

-- above5 ⊆ above2: desdobra as duas definições, desdobra a
-- pertinência de h até virar desigualdade, e omega resolve a aritmética
example : above5 ⊆ above2 := by
  unfold above2 above5
  intro x h
  simp only [Set.mem_ofPred_eq] at h ⊢
  omega
```

== 4.X.2 union-contains / intersection-contained
```lean
-- todo conjunto está contido na união com outro: entra pelo Or.inl
example (A B : Set Nat) : A ⊆ A ∪ B := by
  intro x h
  exact Or.inl h

-- interseção está contida em cada um dos dois: projeta o primeiro campo
example (A B : Set Nat) : A ∩ B ⊆ A := by
  intro x h
  exact h.1
```

== 4.X.3 transitividade e distribuição da inclusão (A6, A7)
```lean
-- A6: transitividade da inclusão, encadeia as duas hipóteses
example : A ⊆ B → B ⊆ C → A ⊆ C := by
  intro hAB hBC x hxA
  exact hBC (hAB hxA)

-- A7: contido em B e em C ⇒ contido na interseção, empacota os dois
example : A ⊆ B → A ⊆ C → A ⊆ B ∩ C := by
  intro hAB hAC x hxA
  exact ⟨hAB hxA, hAC hxA⟩
```

== 4.X.4 empty-subset
```lean
-- ∅ ⊆ A vale vacuamente: a hipótese x ∈ ∅ já é False,
-- então qualquer coisa segue dela (.elim)
example : ∅ ⊆ A := by
  intro x h
  exact h.elim
```

== 4.X.5 empty-vs-singleton
```lean
-- ∅ não tem elemento nenhum; {∅} tem exatamente um elemento
-- (o próprio ∅). São objetos diferentes: |∅| = 0, |{∅}| = 1.
-- Prova: ∅ ∈ {∅} vale por rfl; se ∅ = {∅} isso viraria ∅ ∈ ∅ (False)
example :
    (∅ : Set (Set α)) ≠ ({∅} : Set (Set α)) := by
  intro h
  have hmem : (∅ : Set α) ∈ ({∅} : Set (Set α)) := rfl
  rw [← h] at hmem
  exact hmem
```

== 4.X.6 double-complement ★★
```lean
-- Aᶜᶜ = A: a direção A ⊆ Aᶜᶜ é construtiva (aplica hnx a hx dá False),
-- mas Aᶜᶜ ⊆ A precisa de dupla negação clássica (by_contra)
example : Aᶜᶜ = A := by
  apply Set.ext
  intro x
  constructor
  · -- ¬¬(x ∈ A) → x ∈ A, direção clássica
    intro h
    by_contra hx
    exact h hx
  · -- x ∈ A → ¬¬(x ∈ A), direção construtiva
    intro hx hnx
    exact hnx hx
```

== 4.X.7 cartesian-square ★★
```lean
-- produto cartesiano de Finset é ×ˢ, e .card calcula sozinho
def playerPairs : Finset (Player × Player) :=
  Finset.univ ×ˢ Finset.univ

theorem playerPairs_test : playerPairs.card = 9 := by decide
```

== 4.X.8 successor-composition ★★
```lean
-- plusTwo ∘ plusTwo soma 4: vai (a, a+2) e depois (a+2, a+4)
theorem plusTwo_test (a c : Nat) :
    Relation.Comp plusTwo plusTwo a c ↔ c = a + 4 := by
  constructor
  · rintro ⟨b, hab, hbc⟩
    unfold plusTwo at hab hbc
    omega
  · intro h
    exact ⟨a + 2, rfl, by unfold plusTwo; omega⟩
```

== 4.X.9 converse-subset ★★
```lean
-- de flip R ≤ R segue R = flip R:
-- h y x : R x y → R y x (pois flip R y x = R x y)
-- h x y : R y x → R x y (pois flip R x y = R y x)
-- as duas juntas dão a equivalência ponto a ponto
theorem flip_eq_test {α : Type} (R : Rel α α)
    (h : flip R ≤ R) : R = flip R := by
  funext x y
  apply propext
  constructor
  · intro hxy
    exact h y x hxy
  · intro hyx
    exact h x y hyx
```

== 4.X.10 which-are-transitive ★★
```lean
-- relação finita como Finset de pares: transitividade vira
-- proposição decidível sobre os pares, decide calcula sozinho
abbrev isTransitive (r : Finset (Nat × Nat)) : Prop :=
  ∀ a b c, (a, b) ∈ r → (b, c) ∈ r → (a, c) ∈ r

def r1 : Finset (Nat × Nat) := {(1,2), (2,3), (3,4)}
def r2 : Finset (Nat × Nat) :=
  {(1,2), (2,3), (3,4), (1,3), (2,4)}
def r3 : Finset (Nat × Nat) :=
  {(1,2), (2,3), (3,4), (1,3), (2,4), (1,4)}
def r4 : Finset (Nat × Nat) := {(1,2), (2,1)}
def r5 : Finset (Nat × Nat) := {(1,1), (2,2)}

theorem r1_test : ¬ isTransitive r1 := by decide  -- falta (1,4)
theorem r2_test : ¬ isTransitive r2 := by decide  -- falta (1,4)
theorem r3_test :   isTransitive r3 := by decide  -- fechada
theorem r4_test : ¬ isTransitive r4 := by decide  -- falta (1,1)/(2,2)
theorem r5_test :   isTransitive r5 := by decide  -- fechada
```

== 4.X.11 transitive-iff-comp ★★
```lean
-- R transitiva ↔ R∘R ⊆ R: cada direção é a definição de transitividade
-- desempacotada em termos do intermediário da composição
theorem isTrans_iff_test {α : Type} (R : Rel α α) :
    IsTrans α R ↔ Relation.Comp R R ≤ R := by
  constructor
  · intro hT x z hxz
    obtain ⟨y, hxy, hyz⟩ := hxz
    exact hT.trans x y z hxy hyz
  · intro hcomp
    exact ⟨fun x y z hxy hyz => hcomp x z ⟨y, hxy, hyz⟩⟩
```

== 4.X.12 transitive-not-idempotent ★★
```lean
-- contraexemplo: relação com um único par (0,1).
-- é transitiva vacuamente (a hipótese nunca se satisfaz),
-- mas R∘R é vazia (não existe intermediário), então R∘R ≠ R
def counterexample : Rel Nat Nat := fun a b => a = 0 ∧ b = 1

theorem counterexample_trans : IsTrans Nat counterexample := by
  refine ⟨fun a b c hab hbc => ?_⟩
  obtain ⟨-, hb1⟩ := hab  -- b = 1
  obtain ⟨hb0, -⟩ := hbc  -- b = 0
  omega  -- contradição em b, fecha qualquer meta aritmética

theorem counterexample_different :
    Relation.Comp counterexample counterexample ≠
      counterexample := by
  intro h
  have h01 : counterexample 0 1 := ⟨rfl, rfl⟩
  rw [← h] at h01
  obtain ⟨y, hy1, hy2⟩ := h01
  obtain ⟨-, hy1'⟩ := hy1  -- y = 1
  obtain ⟨hy2', -⟩ := hy2  -- y = 0
  omega
```

== 4.X.13 successor-as-relation
```lean
-- s ∘ s soma 2 duas aplicações de "+1"
def s : Nat → Nat := fun n => n + 1

theorem s_comp_test : s ∘ s = fun n => n + 2 := by
  funext n
  show s (s n) = n + 2
  unfold s
  omega
```

== 4.X.14 leq-as-function
```lean
-- função característica de ≤: decide converte Prop decidível em Bool
def leChar : Nat → Nat → Bool :=
  fun m n => decide (m ≤ n)

theorem leChar_test (m n : Nat) :
    leChar m n = true ↔ m ≤ n :=
  decide_eq_true_iff
```

== 4.X.15 graph-is-functional ★★
```lean
-- kernel de f: x ~ y quando f x = f y — reflexiva (rfl),
-- simétrica (.symm) e transitiva (.trans) porque = já tem essas três
def kernel {α β : Type} (f : α → β) : Rel α α :=
  fun x y => f x = f y

theorem ex_3_12 {α β : Type} (f : α → β) :
    Equivalence (kernel f) :=
  { refl := fun x => rfl
    symm := fun h => h.symm
    trans := fun h1 h2 => h1.trans h2 }

-- Setoid empacota a relação junto com a prova de equivalência
def kernelSetoid {α β : Type} (f : α → β) : Setoid α :=
  ⟨kernel f, ex_3_12 f⟩
```

]
