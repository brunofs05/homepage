// title: Time Series
#import "_utils.typ": collapsible, divider

Notes:
These are personal class notes, not necessarily cohesive, not necessarily structured, and — most importantly — not necessarily accurate! Please check the sources, and feel free to point out any errors via email!


#collapsible(summary: "Anotacoes")[

#divider()

O que veremos, ao longo do curso:
- Arima, Sarima
- MLTables, STL
- ...
Previsão x Descrição x Diagnóstico

#divider()

Normal: $"Cov" <=> "Ind"$
No geral: $"Ind" => "Cov"$

AR(1)

Passeio Aleatório

Tendencia Linear

Estacionariade Fraca

Box-Pierce e Ljung-Box

ARIMA

SARIMA
]

#collapsible(summary: "Comentários da Lista")[

== 1)
F: em uma série temporal as ordens das observações é fundamental, pois cada observação está associada a um instante e pode depender de observações anteriores

== 2)
b) os dados que observamos são *uma* realização ${y_t}$ de um processo ${Y_t}$. Exp: ${Y_t}$ é o processo estocástico que representa todas possibilidades de comportamento da variável ao longo do tempo, enquanto ${y_t}$ é uma realiazação do processo -> os valores efetivamente observados


== 3)
V: Sob normalidade conjunta a distribuição é completamente determinada por $E[Y]$ e momentos de segunda ordem. Onde:

Normalidade Conjunta := o vetor de variáveis $(Y_1,...,Y_n)$ possui uma distribuição normal multivariada conjunta, e a média é o vetor das médias.

Momento de segunda ordem := bruto é $E[Y²]$, como $"Var"(Y) = E[X²]-E[X]²$ e conhecemos a média $E[X]$ e o segundo momento, conhecemos a variância e as covariâncias, logo conhemeos a distribuição conjunta normal

== 4)
F: em ST as observações possuem dependência temporal / ordem natural, na regressão clássica tratamos observações como unidades mais independentes

== 5)
F: Ajustar um modelo com covariáveis temporais não garante que os resíduos deixem de apresentar dependência temporal. O modelo pode não ter capturado toda a estrutura temporal dos dados

Resíduo := é a diferença entre o valor observado e o previsto $e_t = y_t - hat(y_t)$
 

]
