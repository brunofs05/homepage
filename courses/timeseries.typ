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
 
Resíduo sem dependência temporal: significa que o erro em um instante não fornece informação sobre o erro em outro instante. IDealmente, os resíduos são aproximadamente ruído branco: Covariância de ruídos é aproximadamente 0 para instantes diferentes.

== 6)
B) Resíduos de um modelo com covariáveis no tempo ainda correlacionados ao
longo de indicam que: pode restar dependência temporal a modelar

== 7)
F: A ordem das apresentações representa o próprio tempo, embaralhá-las pode invalidar a validação preditiva.

== 8)
A) Os 3 usos complementares de modelar séries são: descrever, diagnosticar (memória no tempo) e prever para a frente

== 9)
C) $R_t$ é o resto depois de retirar a tendência e a sazonalidade:

$y_t = T_t + S_t + R_t$

onde $T_t$ é a tendência, $S_t$ é o padrão sazonal e $R_t$ é o componente restante da série.

Resíduo da decomposição := $R_t = y_t - T_t - S_t$.

== 10)
1 → (i), 2 → (iii), 3 → (ii)

1. Overlay por mês, uma linha por ano → ranking típico dos meses e dispersão entre anos.

2. Série menos média móvel 12 → onda anual na seta do tempo depois de tirar o nível lento.

3. Boxplot por mês → formato do ciclo no ano e se o padrão é estável.

== 11)
F: $y_t - "MA"_(12,t)$ não é necessariamente o resto $R_t$ puro. A média móvel 12 remove/suaviza principalmente o nível lento, mas a sazonalidade $S_t$ ainda pode permanecer.

$y_t = T_t + S_t + R_t$

Logo, subtrair $"MA"_12$ não é o mesmo que remover $T_t$ e $S_t$.

== 12)
F: em séries temporais, o split deve respeitar a ordem temporal; sortear linhas pode misturar passado e futuro e causar *data leakage*.

== 13)
V: $y_t = T_t + S_t + x_t^T beta + R_t$ separa tendência, sazonalidade, covariáveis e resto; olhar apenas $y_t$ mistura esses efeitos.

== 14)
B) $mu_Y(t) = beta_0 + beta_1 t$ depende de $t$, então falha a condição de média constante da estacionariedade fraca.

== 15)
F: o passeio aleatório tem $"Var"(Y_t)=t sigma^2$, portanto a variância depende de $t$ e não é fracamente estacionário.

== 16)
B) o AR(1) com $|phi|<1$ é fracamente estacionário e tem memória linear:
$rho(h)=phi^h$.

== 17)
F: ruído branco exige ausência de correlação entre instantes distintos, mas não exige independência; portanto não é necessariamente IID.

== 18)
F: sair das bandas da ACF indica autocorrelação significativa, mas não necessariamente não-estacionariedade.

== 19)
B) para ruído branco $Y_t=epsilon_t$:
$gamma(r,s)=sigma^2$ se $r=s$ e $0$ se $r != s$.

== 20)
F: estacionariedade fraca não significa ausência de memória; um processo estacionário pode possuir autocorrelação.

== 21)
F: se $rho(h) -> 0$, o preditor linear tende à média $mu$, e não necessariamente ao último valor $Y_n$.

== 22)
Drift:
$(y_T-y_1)/(T-1)=(20-10)/(11-1)=1$.

Logo:
$hat(y_(T+2)|T)=y_T+2(1)=22$.

== 23)
F: no método ingênuo, $hat(y_(T+h)|T)=y_T$ para qualquer $h$, portanto a previsão não depende de $h$.

== 24)
F: valores ajustados $hat(y_t)$ são previsões dentro da amostra; previsão verdadeira é feita para um instante futuro que não participou do ajuste.

== 25)
F: o resíduo é normalmente um erro dentro da amostra, enquanto o erro de previsão a $h$ passos é calculado para uma observação futura que não participou do ajuste.

== 26)
B) no diagnóstico, é essencial que os resíduos tenham média aproximadamente zero e não apresentem autocorrelação.

== 27)
B) no método da média, com resíduos não correlacionados:
$hat(sigma)_h = hat(sigma)sqrt(1+1/T)$.

== 28)
F: bootstrap IID não corrige a dependência temporal existente nos resíduos; primeiro é necessário modelar adequadamente essa memória.

== 29)
V: $"MASE" < 1$ na janela de teste significa erro absoluto médio menor que o do método naive de referência, cujo denominador é calculado no treino.

== 30)
C) o MAPE fica indefinido ou explode quando $y_t approx 0$ e é assimétrico em relação ao erro percentual.

== 31)
B) dentro do intervalo, o escore é a largura; fora, é a largura mais uma penalização proporcional à distância até o extremo, com fator $2/alpha$.

== 32)
F: usualmente aplica-se Box--Cox antes da diferenciação, para estabilizar a variância antes de buscar estacionariedade na média.

== 33)
$(1-B)(1-B^m)y_t = y_t-y_(t-1)-y_(t-m)+y_(t-m-1)$.

== 34)
B) a PACF no lag $k$ é a correlação entre $y_t$ e $y_(t-k)$ depois de retirar os efeitos dos lags $1,...,k-1$.

== 35)
F: no AR(1) estacionário, a ACF decai geometricamente e a PACF corta no lag 1.

== 36)
O AR($p$) é fracamente estacionário se todas as raízes de $phi(z)=0$ satisfazem:
$|z| > 1$.

== 37)
B) em um MA($q$), a ACF corta após $q$ e a PACF decai.

== 38)
B) passeio aleatório:
$"ARIMA"(0,1,0)$ com $C=0$;

passeio com deriva:
$"ARIMA"(0,1,0)$ com $C != 0$.

== 39)
F: com $d=1$, o processo é integrado e a previsão de longo prazo não reverte à média; no passeio aleatório ela permanece associada ao último nível observado.

== 40)
F: AIC/AICc não deve ser usado isoladamente para determinar o $d$ correto; a necessidade de diferenciação deve ser avaliada pela estacionariedade e pelo diagnóstico do modelo.

== 41)
C) se ACF e PACF decaem sem corte claro, pode-se tratar como ARMA($p,q$) e escolher $p,q$ por AICc mantendo o mesmo $d$.

== 42)
No KPSS de nível, a hipótese nula é:
$H_0$: a série é estacionária em nível.

== 43)
F: em $"SARIMA"(p,d,q)(P,D,Q)_m$, o período $m$ normalmente vem da frequência/calendário da série; não é estimado por AIC junto com $P$.

== 44)
F: com ciclo forte, a diferenciação sazonal deve ser considerada antes da diferenciação regular quando apropriado, e $d$ e $D$ são definidos principalmente pelo diagnóstico de estacionariedade, não simplesmente escolhidos por AIC.

== 45)
B) em um modelo SMA sazonal de ordem 1 com período 12, a ACF apresenta pico no lag 12 e corta nos lags sazonais seguintes, enquanto a PACF decai nos lags sazonais.

]
