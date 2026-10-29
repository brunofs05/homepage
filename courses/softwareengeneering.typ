// title: Engenharia de Software
#import "/typst/_utils.typ": collapsible, divider

Notas:
Estas são anotações pessoais de aula — não necessariamente coesas, não necessariamente estruturadas e, o mais importante, não necessariamente precisas! Por favor, verifique as fontes e sinta-se à vontade para apontar eventuais erros por e-mail!

#divider()


#collapsible(summary: "Metodologias Ágeis", open: false)[

  == Contexto

  Metodologia ágil é uma abordagem de desenvolvimento baseada em entregas curtas e incrementais, adaptação a mudanças e colaboração contínua entre equipe e cliente. Ela se opõe ao modelo cascata, em que cada fase só começa quando a anterior termina e o plano raramente muda.

  O *Manifesto Ágil* (2001) resume a ideia em quatro valores. Os itens da direita importam, mas os da esquerda importam mais:

  - Indivíduos e interações _sobre_ processos e ferramentas;
  - Software em funcionamento _sobre_ documentação abrangente;
  - Colaboração com o cliente _sobre_ negociação de contratos;
  - Responder a mudanças _sobre_ seguir um plano.

  == Scrum

  Scrum é um framework ágil para organizar o desenvolvimento de produtos complexos. Não é um processo completo nem uma técnica: é uma estrutura mínima de papéis, eventos e artefatos, dentro da qual o time encaixa seus próprios processos e técnicas.

  === Base: empirismo

  O conhecimento vem da experiência, e as decisões se baseiam no que já é conhecido. Três pilares sustentam isso:

  - *Transparência*: o que importa no processo é visível a todos os envolvidos, com linguagem comum e uma definição compartilhada de "Pronto".
  - *Inspeção*: artefatos e progresso são examinados com frequência, para detectar desvios cedo.
  - *Adaptação*: se algo saiu dos limites aceitáveis, o processo ou o produto é ajustado o quanto antes.

  === Time Scrum

  É formado por três papéis. O time é *multifuncional* (reúne todas as habilidades necessárias) e *autogerenciável* (decide sozinho como fazer o trabalho).

  - *Product Owner (PO)*: uma única pessoa, nunca um comitê, responsável pelo Backlog do Produto e por maximizar o valor do produto. Ordena os itens e garante que estejam claros para todos. A organização precisa respeitar suas decisões.
  - *Time de Desenvolvimento*: entrega um incremento "Pronto" a cada Sprint. Todos são "Desenvolvedores", sem títulos nem sub-times (como um time de testes separado). O tamanho ideal é de 3 a 9 pessoas: abaixo disso falta interação, acima disso a coordenação pesa.
  - *Scrum Master (SM)*: servo-líder que garante que o Scrum seja entendido e aplicado. Remove impedimentos, facilita os eventos e apoia o PO, o time e a organização. Não é chefe nem gerente de projeto.

  === Eventos

  Os eventos criam uma rotina e reduzem reuniões não planejadas. Todos têm duração máxima (*time-box*), e a Sprint contém todos os outros. Durações abaixo são para uma Sprint de 1 mês; Sprints menores têm eventos proporcionalmente menores.

  #table(
    columns: (auto, auto, auto, 1fr),
    align: left,
    [*Evento*], [*Duração máx.*], [*Quem participa*], [*Objetivo*],
    [Sprint], [1 mês], [Time Scrum], [Ciclo de trabalho que produz um incremento "Pronto" e potencialmente lançável.],
    [Planejamento da Sprint], [8 h], [Time Scrum], [Definir *o que* será entregue e *como*, gerando a Meta e o Backlog da Sprint.],
    [Reunião Diária], [15 min], [Time de Desenvolvimento], [Sincronizar o time e planejar as próximas 24 h.],
    [Revisão da Sprint], [4 h], [Time Scrum e stakeholders], [Inspecionar o incremento e adaptar o Backlog do Produto.],
    [Retrospectiva da Sprint], [3 h], [Time Scrum], [Inspecionar a própria forma de trabalhar e criar um plano de melhoria.],
  )

  *Sprint.* Tem duração fixa, que não muda durante a execução, e uma nova Sprint começa assim que a anterior termina. Nela, nada pode colocar em risco a Meta da Sprint, a qualidade não diminui e o escopo pode ser renegociado entre PO e Time de Desenvolvimento. Só o PO pode cancelá-la, e apenas quando a Meta se torna obsoleta, o que é raro.

  *Planejamento.* Responde duas perguntas: _o que_ pode ser entregue nesta Sprint e _como_ o trabalho será feito. O resultado é a *Meta da Sprint*, um objetivo único que dá direção ao trabalho, e o *Backlog da Sprint*.

  *Reunião Diária.* Cada desenvolvedor responde a três perguntas: o que fiz ontem para ajudar a atingir a Meta, o que farei hoje e se vejo algum obstáculo. Não é uma reunião de status para gestores: é um evento do time, para o time.

  *Revisão.* Reunião informal de colaboração, não uma aprovação formal. O PO diz o que está "Pronto", o time demonstra o trabalho e o grupo decide o que fazer a seguir. O resultado é um Backlog do Produto revisado.

  *Retrospectiva.* Acontece depois da Revisão e antes do próximo Planejamento. O time identifica o que foi bem e o que melhorar, em pessoas, processos e ferramentas, e escolhe melhorias para a próxima Sprint.

  === Artefatos

  São representações do trabalho ou do valor, feitos para maximizar a transparência.

  - *Backlog do Produto*: lista ordenada de tudo o que o produto precisa, única fonte de requisitos. Pertence ao PO e nunca está completo. Os itens no topo são mais detalhados que os do fundo, e o *refinamento* contínuo adiciona detalhe, estimativa e ordem.
  - *Backlog da Sprint*: itens escolhidos para a Sprint mais o plano para entregá-los. Pertence ao Time de Desenvolvimento, que é o único a alterá-lo durante a Sprint.
  - *Incremento*: soma de todos os itens concluídos na Sprint com os incrementos anteriores. Ao fim de cada Sprint ele deve estar "Pronto", ou seja, utilizável, mesmo que o PO decida não lançá-lo.

  *Definição de "Pronto"* (_Definition of Done_): entendimento explícito e compartilhado do que significa o trabalho estar completo. Todo o time concorda com ela, e ela tende a ficar mais rigorosa conforme o time amadurece.

]

#collapsible(summary: "SOLID e Padrões de Projeto", open: false)[

  == Conceitos de Python usados nos exemplos

  - *`__init__` e `self`*: `__init__` é o construtor, chamado ao criar um objeto, e inicializa seus atributos. `self` é o próprio objeto: o primeiro parâmetro de todo método de instância, por onde se acessa `self.atributo`.
  - *Subclasse*: classe que herda atributos e métodos de outra (a superclasse) e pode estender ou sobrescrever o comportamento.
  - *`ABC`*: _Abstract Base Class_, o módulo `abc` do Python. Herdar de `ABC` marca a classe como abstrata: ela não pode ser instanciada diretamente e serve de contrato para as subclasses.
  - *`@abstractmethod`*: marca um método que a classe abstrata declara mas não implementa. Toda subclasse concreta é obrigada a sobrescrevê-lo, senão não pode ser instanciada.
  - *`__str__`*: método especial que define a representação em texto do objeto, usada por `print()` e `str()`.

  *Tipagem fraca.* Python não impede que se passe qualquer coisa como parâmetro. Em vez de verificar tipos em todo método, o que deixaria o código lento e poluído, declara-se o comportamento esperado e confia-se em quem chama. Verificações ficam para a fronteira com o mundo externo (entrada do usuário, arquivos, rede).

  == SOLID

  *SRP* (_Single Responsibility Principle_, o S do SOLID): cada componente deve ter uma única responsabilidade, ou seja, um único motivo para mudar.

  - *Code smell*: sintoma de que o design está ruim. O código funciona, mas "cheira mal" por causa de um problema estrutural.
  - *God class*: classe ou método que faz coisas demais, concentrando responsabilidades que deveriam estar separadas.

  Um bom teste: se uma mudança no código não obriga o `main` a mudar junto, o design melhorou.

  *OCP* (_Open/Closed Principle_, o O do SOLID): uma classe deve estar fechada para modificação e aberta para extensão. Estende-se o comportamento criando código novo, sem reescrever o que já funciona.

  == Padrões de Projeto

  São soluções testadas e documentadas para problemas recorrentes de modelagem. A referência é o livro _Design Patterns_ (1994), da *Gang of Four* (GoF), que os divide em três categorias:

  - *Criacionais*: como criar objetos (Factory Method, Abstract Factory, Builder, Prototype, Singleton);
  - *Estruturais*: como combinar classes e objetos em estruturas maiores;
  - *Comportamentais*: como objetos se comunicam e dividem responsabilidades.

  === Simple Factory e Factory Method

  - *Simple Factory*: classe cujo único trabalho é decidir qual objeto concreto criar, tirando essa decisão de quem o consome. Não é um padrão GoF; é didático, útil para entender o Factory Method.
  - *Factory Method*: cada subclasse decide, por meio de um método abstrato sobrescrito, qual objeto concreto criar. Substitui o `if` por polimorfismo e aplica o OCP: novos tipos entram como novas subclasses, sem alterar o código existente.

  === Builder

  Resolve o problema de montar objetos complexos, com muitos parâmetros, como uma requisição HTTP (url, header, token, body...). Uma classe _builder_ monta o objeto passo a passo e entrega o resultado no final.

  _Por que não passar tudo direto no construtor?_ O Builder clássico nasceu do *construtor telescópico*: para pular um parâmetro opcional era preciso passar `null` em todos os anteriores, na ordem certa. Em Python esse problema quase não existe, porque `kwargs` e parâmetros nomeados com valor padrão (`parametro=valor_padrao`) já o resolvem.

]
