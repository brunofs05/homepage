// title: Software Engineering
#import "../_utils.typ": collapsible, divider

Notes:
These are personal class notes—not necessarily cohesive, not necessarily structured, and—most importantly—not necessarily accurate!

Please check the sources, and feel free to point out any errors via email!

#divider()

#collapsible(summary: "Metodologias Ágeis", open: true)[

  Metodologia Ágil é uma abordagem de desenvolvimento que prioriza entregas rápidas e incrementais, adaptação a mudanças e colaboração contínua entre equipe e cliente. O foco está em responder às mudanças em vez de seguir um plano rígido — ao contrário das metodologias tradicionais (como o modelo cascata), onde cada fase deve ser concluída antes da próxima começar.

  Existe um Manifesto Ágil, escrito em 2001 pelos seus criadores, que sintetiza os principais valores em um texto curto e direto. Ele estabelece quatro valores centrais:
  - Indivíduos e interações mais que processos e ferramentas;
  - Software em funcionamento mais que documentação abrangente;
  - Colaboração com o cliente mais que negociação de contratos;
  - Responder a mudanças mais que seguir um plano.
  Vale a pena ler o manifesto original em agilemanifesto.org.

  === Scrum

  Scrum é um framework ágil usado para organizar e gerenciar o desenvolvimento de projetos, essencialmente de software. A metodologia representa os princípios e valores; o Scrum é uma ferramenta que aplica esses princípios de forma estruturada e prática. Scrum não é um processo completo nem uma técnica de desenvolvimento — é um framework dentro do qual você emprega seus próprios processos e técnicas.

  Definição formal (Scrum Guide): _"Um framework dentro do qual pessoas podem tratar e resolver problemas complexos e adaptativos, enquanto produtiva e criativamente entregam produtos com o mais alto valor possível."_

  Scrum é: leve, simples de entender e extremamente difícil de dominar.

  ==== Componentes do Scrum

  O Scrum é composto por quatro elementos que se integram pelas regras:

  - *Papéis*: definem as responsabilidades de cada pessoa do Time Scrum.
  - *Eventos*: cerimônias com duração máxima (time-box) que criam ritmo, inspeção e adaptação.
  - *Artefatos*: representações do trabalho e do valor, projetadas para maximizar a transparência.
  - *Regras*: integram papéis, eventos e artefatos, definindo como tudo se relaciona. São descritas no próprio Scrum Guide.

  ==== Teoria do Scrum

  O Scrum é fundamentado no empirismo — o conhecimento vem da experiência e as decisões são baseadas no que é conhecido. Três pilares sustentam isso:

  - *Transparência*: aspectos significativos do processo devem estar visíveis a todos os responsáveis pelos resultados. Exige linguagem comum e uma definição compartilhada de "Pronto".
  - *Inspeção*: os artefatos e o progresso devem ser inspecionados com frequência suficiente para detectar variações indesejadas, sem que isso atrapalhe a execução.
  - *Adaptação*: se a inspeção revela que algo desviou dos limites aceitáveis, o processo ou o material deve ser ajustado o mais rápido possível.

  ==== Time Scrum

  O Time Scrum é composto pelo Product Owner, o Time de Desenvolvimento e o Scrum Master. Times Scrum são *multidisciplinares/multifuncionais* (possuem todas as competências necessárias para completar o trabalho sem depender de fora da equipe) e *autogerenciáveis/auto-organizáveis* (escolhem a melhor forma de completar o trabalho, sem serem dirigidos por outros externos ao time). Ambos os termos são válidos — variam apenas na tradução do inglês _self-organizing_ e _cross-functional_.

  O modelo de time no Scrum é projetado para aperfeiçoar a flexibilidade, criatividade e produtividade. Times entregam de forma iterativa e incremental, garantindo que uma versão potencialmente funcional do produto esteja sempre disponível.

  ===== Product Owner (PO)

  É a única pessoa responsável por gerenciar o Backlog do Produto e por maximizar o valor do produto e do trabalho do Time de Desenvolvimento. Suas responsabilidades incluem:
  - Expressar claramente os itens do Backlog do Produto;
  - Ordenar os itens para alcançar melhor as metas;
  - Garantir que o Backlog esteja visível, transparente e claro para todos;
  - Garantir que o Time de Desenvolvimento entenda os itens no nível necessário.

  O Product Owner é uma *pessoa*, não um comitê. Para que tenha sucesso, toda a organização deve respeitar suas decisões. Ninguém pode dar ordens ao Time de Desenvolvimento que contrariem o PO.

  ===== Time de Desenvolvimento

  Consiste em profissionais que entregam um incremento "Pronto" ao final de cada Sprint. Características:
  - Auto-organizados: ninguém (nem mesmo o Scrum Master) diz ao time *como* transformar o Backlog em incremento;
  - Multifuncionais: possuem todas as habilidades necessárias como equipe;
  - O Scrum não reconhece títulos para seus integrantes — todos são chamados de "Desenvolvedor", independente da especialidade;
  - Não existem sub-times dedicados (ex: time de testes separado do time de desenvolvimento).

  *Tamanho ideal*: entre 3 e 9 pessoas. Menos de 3 reduz a interação e a produtividade; mais de 9 gera complexidade de coordenação excessiva. Product Owner e Scrum Master não são contados nesse número, a menos que também executem trabalho do Backlog da Sprint.

  ===== Scrum Master (SM)

  É um servo-líder: garante que o Scrum seja entendido e corretamente aplicado, removendo impedimentos e protegendo o time de interferências externas. Não é chefe nem gerente de projeto.

  Serve o *Product Owner*: encontrando técnicas para gerenciar o Backlog, comunicando visão e objetivos ao time, ensinando a criar itens claros e concisos, facilitando eventos Scrum.

  Serve o *Time de Desenvolvimento*: treinando em autogerenciamento e interdisciplinaridade, removendo impedimentos, facilitando eventos, ajudando o time a criar produtos de alto valor.

  Serve a *Organização*: liderando a adoção do Scrum, planejando implementações, ajudando funcionários e partes interessadas a entender o desenvolvimento empírico de produto, trabalhando com outros Scrum Masters para aumentar a eficácia do Scrum na organização.

  ==== Eventos Scrum

  Eventos prescritos são usados para criar uma rotina e minimizar a necessidade de reuniões não planejadas. Todos são *time-boxed* (possuem duração máxima definida). A Sprint é o container de todos os outros eventos.

  ===== Sprint

  O coração do Scrum. É um ciclo de trabalho de *até 1 mês* (time-box fixo) durante o qual um incremento "Pronto", utilizável e potencialmente lançável do produto é criado. A duração da Sprint é fixa e não pode ser alterada durante sua execução. Uma nova Sprint inicia imediatamente após o término da anterior.

  Durante a Sprint:
  - Não são feitas mudanças que coloquem em risco o objetivo da Sprint;
  - As metas de qualidade não diminuem;
  - O escopo pode ser clarificado e renegociado entre PO e Time de Desenvolvimento.

  A Sprint pode ser *cancelada* — somente o Product Owner tem autoridade para isso. Ocorre quando o objetivo da Sprint se torna obsoleto (mudança de direção da organização, mercado ou tecnologia). Cancelamentos consomem recursos e são traumáticos para o time; são muito incomuns.

  ===== Planejamento da Sprint _(Sprint Planning)_

  *Duração máxima*: 8 horas para Sprint de 1 mês; proporcional para Sprints menores.
  *DEVEM participar (falar e decidir)*: todo o Time Scrum (PO + Time de Desenvolvimento + Scrum Master).
  *Podem participar*: outras pessoas convidadas pelo Time de Desenvolvimento para fornecer opinião técnica ou de domínio.

  Responde duas perguntas:
  - *O que* pode ser entregue como resultado do incremento desta Sprint? O Time de Desenvolvimento prevê funcionalidades; o PO apresenta o objetivo e os itens prioritários do Backlog.
  - *Como* o trabalho escolhido será feito? O Time de Desenvolvimento decompõe os itens em tarefas, frequentemente em unidades de 1 dia ou menos.

  O resultado é a *Meta da Sprint* (Sprint Goal) — objetivo único que dá direção e coesão ao trabalho — e o *Backlog da Sprint*.

  ===== Reunião Diária _(Daily Scrum)_

  *Duração máxima*: 15 minutos.
  *DEVEM participar (falar)*: Time de Desenvolvimento. O Scrum Master garante que aconteça e que o time respeite o time-box.
  *Podem participar (observar, sem falar)*: Scrum Master, PO e outras partes interessadas — mas somente o Time de Desenvolvimento tem a palavra.
  *Frequência*: diária, mesmo horário e local, para reduzir complexidade.

  Cada membro do Time de Desenvolvimento esclarece:
  - O que eu fiz ontem que ajudou o time a atingir a meta da Sprint?
  - O que farei hoje para ajudar o time a atingir a meta da Sprint?
  - Vejo algum obstáculo que impeça a mim ou ao time?

  Objetivo: sincronizar atividades, inspecionar progresso em direção à meta e criar um plano para as próximas 24h. Não é uma reunião de status para gestores — é um evento de planejamento do time para o time.

  ===== Revisão da Sprint _(Sprint Review)_

  *Duração máxima*: 4 horas para Sprint de 1 mês; proporcional para menores.
  *DEVEM participar (falar)*: Time Scrum.
  *Podem participar*: stakeholders-chave convidados pelo PO.

  Ocorre ao final da Sprint para inspecionar o incremento e adaptar o Backlog do Produto. É uma reunião informal de colaboração — não uma reunião de status ou aprovação formal.

  O que acontece:
  - PO esclarece quais itens estão "Prontos" e quais não estão;
  - Time de Desenvolvimento demonstra o trabalho pronto e responde perguntas;
  - Grupo colabora sobre o que fazer a seguir;
  - PO discute o estado atual do Backlog e projeções de datas.

  O resultado é um *Backlog do Produto revisado*, que define a entrada mais provável para o próximo Planejamento da Sprint.

  ===== Retrospectiva da Sprint _(Sprint Retrospective)_

  *Duração máxima*: 3 horas para Sprint de 1 mês; proporcional para menores.
  *DEVEM participar (falar)*: todo o Time Scrum. O Scrum Master participa como membro do time, não apenas como facilitador.
  *Quando*: ocorre após a Revisão da Sprint e antes do próximo Planejamento da Sprint.

  Oportunidade para o Time Scrum inspecionar a si próprio e criar um plano de melhoria concreto. Foca em pessoas, relacionamentos, processos e ferramentas.

  Propósito:
  - Inspecionar como a última Sprint foi em relação a pessoas, processos e ferramentas;
  - Identificar o que foi bem e as potenciais melhorias, ordenando-as;
  - Criar um plano para implementar melhorias na próxima Sprint.

  ==== Work Agreement (Acordo de Trabalho)

  O Work Agreement é um conjunto de regras, normas e combinados definidos pelo próprio time sobre como ele vai trabalhar junto. Não é imposto externamente — o time cria, revisa e é dono dessas regras. Exemplos típicos: horário de trabalho, canais de comunicação, definição de "Pronto", critérios de code review, forma de conduzir a Daily. O objetivo é criar um ambiente de trabalho previsível, respeitoso e produtivo, reduzindo ambiguidades e conflitos no dia a dia.

  ==== Artefatos do Scrum

  Artefatos são representações do trabalho ou do valor. São especificamente projetados para maximizar a transparência das informações chave, de modo que todos tenham o mesmo entendimento. Os três artefatos do Scrum são:

  ===== Backlog do Produto _(Product Backlog)_

  Lista ordenada de tudo o que é necessário no produto — é a única fonte de requisitos para qualquer mudança. O Product Owner é responsável por ele. Nunca está completo: evolui junto com o produto e o ambiente. É dinâmico e existirá enquanto o produto existir. Cada item possui: descrição, ordem, estimativa e valor.

  *Refinamento do Backlog*: processo contínuo de adicionar detalhes, estimativas e ordem aos itens. Usualmente não consome mais de 10% da capacidade do Time de Desenvolvimento. Itens no topo da lista (maior prioridade) devem ser mais detalhados e estimados com mais precisão do que itens no fundo.

  ===== Backlog da Sprint _(Sprint Backlog)_

  Conjunto de itens do Backlog do Produto selecionados para a Sprint, mais o plano para entregar o incremento e atingir a meta da Sprint. Pertence exclusivamente ao Time de Desenvolvimento — somente ele pode alterá-lo durante a Sprint. É uma imagem em tempo real do trabalho planejado.

  ===== Incremento

  É a soma de todos os itens do Backlog do Produto completados durante a Sprint mais o valor de todos os incrementos anteriores. Ao final de cada Sprint, o incremento deve estar "Pronto" — utilizável, independente de o PO decidir lançá-lo ou não.

  ===== Definição de "Pronto" _(Definition of Done)_

  Entendimento compartilhado e explícito do que significa o trabalho estar completo. Garante transparência e alinha expectativas de todo o time. Todos os membros do Time Scrum devem concordar com ela. Se a organização não tem uma definição padrão, o Time de Desenvolvimento deve criar uma adequada ao produto. Com o amadurecimento do time, a definição de "Pronto" tende a se tornar mais rigorosa.

]
