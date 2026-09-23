// title: Natural Language Processing
#import "_utils.typ": collapsible, divider

Notes:
These are personal class notes, not necessarily cohesive, not necessarily structured, and — most importantly — not necessarily accurate! Please check the sources, and feel free to point out any errors via email!

#divider()

#collapsible("1. O estudo formal da língua natural", open: true) [

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

]
