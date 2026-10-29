// title: Processamento de Linguagem Natural
#import "/typst/_utils.typ": collapsible, divider

Notas:
Estas são anotações pessoais de aula — não necessariamente coesas, não necessariamente estruturadas e, o mais importante, não necessariamente precisas! Por favor, verifique as fontes e sinta-se à vontade para apontar eventuais erros por e-mail!

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

#collapsible(summary: "3. Lógica", open: false)[

== 3.1 Provas em Lean
- Lean é linguagem de programação E assistente de prova: a mesma linguagem escreve funções e provas sobre elas
- `Prop` := tipo das proposições (enunciados verdadeiros ou falsos). Proposição é um tipo e prova é um termo desse tipo, então provar é construir um valor
- Declarar uma proposição não é decidi-la: `#check` pergunta o tipo, não avalia se é verdade (`1 = 2` é um `Prop` perfeitamente válido)
- Prova como termo: `theorem OneEqSelf : 1 = 1 := Eq.refl 1`. Declarar teorema é parecido com declarar função
- `by` abre o modo de táticas: descreve-se como montar a prova e Lean constrói o termo (`#print` mostra qual foi). Útil quando o termo escrito à mão fica grande
- `rfl` fecha igualdade quando os dois lados reduzem à mesma expressão por computação (consequência do CIC). Leis algébricas como `Nat.mul_comm` não são por definição, precisam ser aplicadas com `exact`
- Sistema dedutivo := conjunto de regras de dedução. `Prop` implementa a dedução natural de Gentzen (1930): `Γ ⊢ α` := α deriva de Γ, `⊢ α` := α é válida (tautologia)
- Cada conectivo tem regra de introdução (como construir uma prova que o usa) e de eliminação (como usar uma prova que o tem)

#table(
  columns: (auto, 1fr, 1fr),
  align: left,
  [*Conectivo*], [*Introdução*], [*Eliminação*],
  [`→`], [`intro` (supõe o antecedente)], [modus ponens: `h hP`. `apply` raciocina de trás para frente, `exact` fecha com hipótese de mesmo tipo, `assumption` procura a hipótese sozinha],
  [`∧`], [`constructor` (dois objetivos), `⟨_, _⟩`, `And.intro`], [projeções `.1`/`.2` (`.left`/`.right`), `obtain ⟨a, b⟩ := h`],
  [`∨`], [basta um lado: `left`/`right` (`Or.inl`/`Or.inr`)], [prova por casos (`Or.elim`): `cases h with`, concluir nos dois casos],
  [`¬`], [`¬P` é `P → False`: `intro hP` e derivar `False`], [`absurd`; ex falso quodlibet: de `False` sai qualquer coisa (`False.elim`)],
  [`↔`], [`constructor` (uma prova para cada `→`), `Iff.intro`], [`h.mp`, `h.mpr`],
  [`∀`], [`intro x` com x arbitrário (entra no contexto como variável)], [aplicação: `h d` prova `P d`],
  [`∃`], [precisa de testemunha: `use d`, `Exists.intro`], [`obtain ⟨d, hd⟩ := h` dá nome à testemunha sem saber qual é],
)

- Lógica construtiva (intuicionista) := provar `P ∨ Q` exige saber qual lado vale. Não assume que toda proposição é verdadeira ou falsa
- Lógica clássica acrescenta o terceiro excluído `Classical.em : P ∨ ¬P`, de onde vêm `by_cases` (divide em P e ¬P) e `by_contra` (redução ao absurdo: supõe `¬P` e deriva `False`)
- Em Lean um tipo pode ser vazio, ao contrário do domínio não vazio da FOL clássica. Por isso `(∀ x, P x) → ∃ x, P x` só prova com um `u : U` explícito (ou a classe `Nonempty`)
- Indução: `induction n with | zero | succ a ih`. Caso base em `Nat.zero`, passo assume a propriedade em `a` (hipótese `ih`) e prova para `a + 1`
- Extensionalidade: `def` define funções no sentido intensional (o algoritmo), mas duas definições distintas podem ser a mesma função extensional (mesma tabela entrada → saída). `funext` reduz `f = g` a mostrar que coincidem em todo ponto
- `decide` computa a decisão dentro do kernel (simples, pode ser lenta); `native_decide` compila para código nativo antes de executar. `omega` e `simp` aparecem quando forem necessárias

== 3.2 Lógica Proposicional
- Em `Prop` vale a irrelevância da prova: Lean não distingue provas diferentes de uma proposição, então não dá para casar padrão numa prova de `p ∧ q`. `Prop` não é dado, não é computável
- Para manipular fórmulas como dado e decidir consequência, usa-se um tipo indutivo `Formula` (átomos com nome `String`, `top`, `bot`, `neg`, `conj`, `disj`). Implicação e bicondicional são definidas: `impl f g := disj (neg f) g`, `iff` := conjunção das duas implicações
- Sem operadores infixos não há ambiguidade nem precedência. "Maria é jovem e bonita ou triste" vira `conj j (disj b t)` ou `disj (conj j b) t`, leituras diferentes
- Linguagem proposicional := todas as fórmulas construíveis sobre um vocabulário de átomos. `names` extrai o vocabulário (ordenado e sem repetição). `j`, `b`, `t` são identificadores da metalinguagem (Lean), as strings `"MJ"`, `"MB"`, `"MT"` são o vocabulário da fórmula
- `conjs` e `disjs` recebem lista. Base da recursão: conjunção vazia é `top` e disjunção vazia é `bot` (elementos neutros). A lista fica fora do construtor, pois indutivo aninhado é mais difícil de manipular
- Como `Formula` é dado, dá para contar operadores, medir profundidade etc., coisa impossível com `Prop`

=== Semântica
- `Formula.eval f value` calcula o valor de verdade por recursão, com `value : String → Bool` (valoração). Só o caso `atom` consulta a valoração, os demais combinam subfórmulas
- Tautologia (válida, `⊨ α`) := verdadeira em toda valoração. Contradição (insatisfatível) := falsa em toda valoração. Satisfatível := alguma valoração a torna verdadeira. Contingente := verdadeira em alguma e falsa em outra
- Toda tautologia é satisfatível, mas nem toda satisfatível é tautologia. Se α é contradição, então `⊨ ¬α`
- `allVals` gera todas as valorações (2ⁿ para n átomos), o que dá a tabela verdade. `tautology` percorre com `all`, `satisfiable` com `any`, `contradiction := !satisfiable`. Funciona porque os átomos são finitos
- Consequência lógica: `P ⊨ Q` sse `⊨ P → Q` sse `P ∧ ¬Q` é contradição (é assim que `implies` é implementado). Com várias premissas, `{P₁, …, Pₙ} ⊨ α` sse `⊨ (P₁ ∧ … ∧ Pₙ) → α`
- Equivalência `α ≡ β` := mesmo valor em toda valoração, ou seja, `implies` nos dois sentidos. Todas as tautologias são equivalentes entre si, o mesmo vale para as contradições
- Semântica por atualização: parte-se do conjunto de todas as valorações e `update` mantém só as que satisfazem a fórmula. Contradição esvazia o conjunto, tautologia não tira nada

=== Meta-teoremas e ponte com Prop
- Meta-teoremas são teoremas sobre PL escritos em Lean, não fórmulas de PL. Mostram que as definições são consistentes (ex: toda tautologia é equivalente a `top`, a negação de tautologia é contradição, princípio da contraposição `F₁ ⊨ F₂` sse `¬F₂ ⊨ ¬F₁`)
- `Formula.denote f v : Prop` troca cada construtor de `Formula` pelo conectivo de `Prop` (`conj` vira `∧`, `neg` vira `¬`)
- `eval_iff_denote`: `eval = true ↔ denote`, provado por indução em f. As duas leituras concordam: calcular o valor de verdade e provar a proposição correspondente

== 3.3 Lógica de Primeira Ordem
- Em PL, "Toda maçã é vermelha" seria um átomo indivisível, sem capturar o quantificador nem a relação entre maçã e cor. FOL (lógica de predicados) acrescenta: termos (variáveis ou funções aplicadas a termos), predicados n-ários sobre termos, `∀` e `∃`
- "Primeira ordem" := quantifica apenas sobre indivíduos do domínio

=== Sintaxe
- `Variable` := nome + índice (lista de naturais para gerar variáveis novas). `Term` := `var v` ou `struct nome args` (símbolo funcional aplicado). Constante := função de aridade zero (`struct "c" []`)
- `Formula α` é parametrizada pelo tipo dos termos: `Formula Variable` só tem variáveis, `Formula Term` é a sintaxe completa. Construtores: `atom`, `eq`, `top`, `bot`, `neg`, `impl`, `equi`, `conj`, `disj`, `forall_`, `exists_`
- Linguagem de primeira ordem := fórmulas construíveis a partir de um vocabulário de símbolos predicativos e funcionais
- Em `∀x F` (ou `∃x F`) o quantificador liga as ocorrências de x em F que não estejam ligadas por um quantificador interno. Fórmula aberta := tem ocorrência livre de variável. Fechada (sentença) := não tem. `freeVars` coleta as livres e filtra a variável de cada quantificador
- Termo t é livre para v em F quando substituir v por t não faz nenhuma variável de t ser capturada por um quantificador. Se não for, renomeia-se as variáveis ligadas de F (variante alfabética) e a substituição passa a ter o significado certo

=== Semântica
- Em PL basta uma valoração. Em FOL a interpretação é uma estrutura: um domínio D mais a interpretação dos símbolos (predicados viram relações em D, símbolos funcionais viram funções em D)
- Como termos têm variáveis, também é preciso uma atribuição `Assign D := Variable → D`. `g[v := d]` (`Assign.update`) muda só o valor de v
- `FInterp` interpreta símbolos funcionais, `liftAssign` interpreta termos por recursão, `Interp` interpreta predicados em `Bool`
- `Formula.eval f dom I g tval` avalia por recursão. Os quantificadores percorrem `dom` (`all` para `∀`, `any` para `∃`), então o domínio precisa ser finito e enumerável. Em domínios infinitos não existe processo de decisão
- Exemplo: um predicado binário `E` sobre quatro vértices é um grafo direcionado, e `E x y` é uma aresta de x para y. Símbolos fora do vocabulário ou com aridade errada avaliam silenciosamente para `false`
- `Fin n` := naturais menores que n, útil para domínios finitos. `Fin.mk` exige prova de que o número é menor que o limite
- Para sentenças a verdade não depende de g, mas a definição passa por subfórmulas abertas (ex: "Todo mestre tem um aprendiz" e depois "Ele tem um aprendiz", como os pronomes da língua natural)
- Válida (`⊨ α`) := verdadeira em toda interpretação. `P ⊨ C` := todo modelo de P é modelo de C. Não há equivalente de `allVals` em FOL, então não se decide `P ⊨ C`: só dá para refutar achando um contraexemplo (`I ⊨ P` e `I ⊭ C`)

=== Ponte com Prop
- `Denot D := String → List D → Prop` interpreta predicados em `Prop`. `denote` troca cada construtor pelo conectivo de Lean, e `forall_` vira o próprio `∀`
- `eval_iff_denote` agora precisa da hipótese `hdom : ∀ d, d ∈ dom` (a lista contém todos os elementos), contrapartida formal da limitação de só calcular quantificadores em domínios finitos
- `denote` não depende de lista: traduz a fórmula para `Prop` e permite provar fatos em domínios infinitos (ex: `∀x ∃y R[x,y]` nos naturais com R como `<`, testemunha `a + 1`)
- Em Prop: `Valid` := verdadeira em todo modelo, `Satisfiable` := algum modelo a torna verdadeira, `Implies f g := Valid (impl f g)`
- Com símbolos funcionais a estrutura vira a tripla `(D, I, F)`, e `ValidT` quantifica também sobre `FInterp` e usa `liftAssign`

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
