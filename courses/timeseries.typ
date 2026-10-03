// title: Time Series
#import "_utils.typ": collapsible, divider

Notas:
Estas são anotações pessoais de aula — não necessariamente coesas, não necessariamente estruturadas e, o mais importante, não necessariamente precisas! Por favor, verifique as fontes e sinta-se à vontade para apontar eventuais erros por e-mail!

#divider()

#collapsible(summary: "Anotações da A1")[


== 1. Panorama: processo, realização e os 3 usos

- *Série temporal (tempo discreto):* observações $y_1, dots, y_n$ indexadas no tempo. A *ordem importa*: cada $y_t$ pode depender do passado.
- *Processo* ${Y_t}$: a família de variáveis aleatórias (todas as trajetórias possíveis). *Realização* ${y_t}$: a *única* trajetória que de fato observamos.
- *Três usos complementares:* *descrever* (tendência, sazonalidade), *diagnosticar* (sobrou memória no tempo?) e *prever* para a frente.
- Diferença para a regressão tabular: não é só a forma do modelo, é que as observações são *dependentes* e têm ordem natural. Mesmo com covariáveis no tempo, os resíduos *podem* continuar dependentes (resíduo com ACF ≠ 0 $=>$ ainda há estrutura a modelar).
- *Split treino/teste é cronológico.* Sortear/embaralhar linhas mistura passado e futuro (*data leakage*) e invalida a validação preditiva.

#divider()

== 2. Decomposição $y_t = T_t + S_t + R_t$

$ y_t = T_t + S_t + R_t quad => quad R_t = y_t - T_t - S_t $

- $T_t$: *tendência*, nível de longo prazo.
- $S_t$: *sazonalidade*, padrão que se repete no calendário com período $m$ (12 mensal, 4 trimestral, 7 diário com ciclo semanal).
- $R_t$: *resto* (o que sobra depois de nomear $T_t$ e $S_t$). Espera-se algo parecido com ruído branco.
- Com covariáveis: $y_t = T_t + S_t + x_t^T beta + R_t$. Olhar só o gráfico de $y_t$ mistura calendário/nível com o que as covariáveis explicariam.
- Multiplicativo: $y_t = T_t S_t R_t$; tomando $log$ vira aditivo.
- *Média móvel de janela 12*, $"MA"_(12,t)$: apaga o ciclo anual e deixa o nível lento ($approx T_t$). Logo $y_t - "MA"_(12,t) approx S_t + R_t$, *não* é o resto puro.

*Três gráficos para a sazonalidade mensal:*

#table(
  columns: (auto, 1fr),
  align: left,
  [*Gráfico*], [*O que mostra*],
  [Overlay (eixo = mês, uma linha por ano)], [formato do ciclo no ano e se o padrão é estável entre anos],
  [Boxplot por mês], [ranking típico dos meses e dispersão entre anos],
  [$y_t - "MA"_12$ no calendário real], [onda anual na seta do tempo depois de tirar o nível lento],
)

#divider()

== 3. Ferramentas de conta: esperança, variância, covariância

*Propriedades (valem para tudo que vem depois):*

- $E[a X + b Y + c] = a E[X] + b E[Y] + c$ (linearidade, sempre vale).
- $"Var"(X) = E[X^2] - E[X]^2$ (2º momento bruto menos quadrado da média).
- $"Cov"(X,Y) = E[X Y] - E[X]E[Y]$ e $"Cov"(X,X) = "Var"(X)$.
- $"Var"(a X + b) = a^2 "Var"(X)$.
- $"Cov"(a X + b, c Y + d) = a c "Cov"(X,Y)$.
- $"Var"(X + Y) = "Var"(X) + "Var"(Y) + 2 "Cov"(X,Y)$. Se as parcelas são *não correlacionadas*, a variância da soma é a soma das variâncias: $"Var"(sum_i epsilon_i) = n sigma^2$.
- Independentes $=>$ $"Cov" = 0$ (a volta *não* vale em geral). Sob *normalidade conjunta*, $"Cov" = 0 <=> $ independência.
- Sob normalidade conjunta, a média e as covariâncias (2º momento) determinam toda a distribuição do processo.

*Funções de um processo:*
- Média: $mu_Y (t) = E[Y_t]$.
- Autocovariância: $gamma(r,s) = "Cov"(Y_r, Y_s)$, e $gamma(t,t) = "Var"(Y_t)$.
- Estacionário: $gamma(h) = "Cov"(Y_t, Y_(t+h))$, $quad rho(h) = gamma(h) / gamma(0)$.

#divider()

== 4. Estacionariedade fraca

Um processo é *fracamente estacionário* se:
+ $E[Y_t] = mu$ é *constante* em $t$;
+ $"Var"(Y_t) = gamma(0) < infinity$ é finita e constante;
+ $"Cov"(Y_t, Y_(t+h)) = gamma(h)$ depende *só de $h$* (não de $t$).

Propriedades: $rho(0) = 1$, $quad |rho(h)| <= 1$, $quad rho(h) = rho(-h)$.

*Fraca* $eq.not$ *sem memória*: um estacionário pode ter autocorrelação (ex.: AR(1)). *Estrita* (distribuição conjunta invariante) implica fraca (com variância finita); sob normalidade conjunta, fraca $=>$ estrita.

*Receita para testar um modelo:* calcule $E[Y_t]$, $"Var"(Y_t)$ e $"Cov"(Y_t, Y_(t+h))$ e veja se dependem de $t$.

#divider()

== 5. Ruído branco (WN) e as bandas da ACF

*Inovações* $epsilon_t$ (ruído branco, $"WN"(0, sigma^2)$):

$ E[epsilon_t] = 0, quad "Var"(epsilon_t) = sigma^2, quad "Cov"(epsilon_s, epsilon_t) = 0 " para " s != t $

- $gamma(h) = sigma^2$ se $h = 0$ e $0$ se $h != 0$; $quad rho(h) = 0$ para $h != 0$.
- É fracamente estacionário e *sem memória linear*.
- IID$(0,sigma^2)$ $=>$ WN, mas WN $arrow.r.not$ IID (não correlacionado não é independente). Gaussiano: WN $<=>$ IID.
- Bandas da ACF amostral: $plus.minus 1.96 / sqrt(n)$. Sob WN, cerca de 5% dos lags saem da banda *só por acaso*. Sair da banda indica autocorrelação, *não* necessariamente não-estacionariedade.

#divider()

== 6. Lag, ACF e PACF

- *Lag $k$:* defasagem de $k$ instantes. $y_(t-k)$ é o valor $k$ passos atrás.
- *Operador defasagem* (backshift): $B y_t = y_(t-1)$ e $B^k y_t = y_(t-k)$. Diferença: $(1-B) y_t = y_t - y_(t-1)$. Diferença sazonal: $(1-B^m) y_t = y_t - y_(t-m)$.
- *ACF* (autocorrelação no lag $h$): $rho(h) = "Cor"(Y_t, Y_(t+h)) = gamma(h)/gamma(0)$. Amostral:

$ hat(gamma)(h) = 1/n sum_(t=1)^(n-h) (y_t - overline(y))(y_(t+h) - overline(y)), quad r_h = hat(gamma)(h) / hat(gamma)(0) $

- *PACF* no lag $k$: correlação entre $y_t$ e $y_(t-k)$ *depois de retirar o efeito dos lags $1, dots, k-1$* (é o último coeficiente $phi_(k k)$ de um AR($k$) ajustado). No lag 1, PACF = ACF.

*Assinaturas para identificação:*

#table(
  columns: (auto, 1fr, 1fr),
  align: left,
  [*Modelo*], [*ACF*], [*PACF*],
  [AR($p$)], [decai (geométrica/oscila)], [*corta* após $p$],
  [MA($q$)], [*corta* após $q$], [decai],
  [ARMA($p,q$)], [decai], [decai (nenhuma corta)],
  [Ruído branco], [$approx 0$ em todos os lags], [$approx 0$ em todos os lags],
  [Passeio aleatório], [decai muito devagar, $r_1 approx 1$], [pico no lag 1],
)

*Sazonal (período $m = 12$):* SAR(1): PACF com pico no lag 12 e ACF decaindo em 12, 24, 36. SMA(1): ACF com pico no lag 12 e corte depois; PACF decai nos lags sazonais.

#divider()

== 7. Modelos e contas de estacionariedade

*Tendência linear:* $Y_t = beta_0 + beta_1 t + epsilon_t$
- $E[Y_t] = beta_0 + beta_1 t$ depende de $t$ $=>$ *falha a condição 1*. $"Var"(Y_t) = sigma^2$ e $"Cov"$ = a do ruído branco. Não é estacionário só por causa da média.
- Remoção: diferenciar, $Y_t - Y_(t-1) = beta_1 + epsilon_t - epsilon_(t-1)$, que tem média constante.

*Passeio aleatório:* $Y_t = Y_(t-1) + epsilon_t = sum_(i=1)^t epsilon_i$ (com $Y_0 = 0$)
- $E[Y_t] = 0$, $quad "Var"(Y_t) = t sigma^2$ (cresce com $t$), $quad gamma(r,s) = min(r,s) sigma^2$ $=>$ *não estacionário* (falha a variância).
- Com deriva $delta$: $Y_t = delta + Y_(t-1) + epsilon_t$, $E[Y_t] = delta t$.
- A diferença $Y_t - Y_(t-1) = epsilon_t$ é WN. É o ARIMA(0,1,0).

*AR(1):* $Y_t = phi Y_(t-1) + epsilon_t$, com $epsilon_t$ não correlacionado com $Y_(t-1)$
- Se $|phi| < 1$ ("esqueceu o início"): $Y_t = sum_(j >= 0) phi^j epsilon_(t-j)$, $E[Y_t] = 0$.
- Variância: $gamma(0) = phi^2 gamma(0) + sigma^2 => gamma(0) = sigma^2 / (1 - phi^2)$.
- Multiplicando por $Y_(t-h)$ e tomando $E$: $gamma(h) = phi gamma(h-1) = phi^h gamma(0)$, logo $rho(h) = phi^h$.
- *Fracamente estacionário, com memória:* ACF decai geometricamente, PACF corta no lag 1.
- $phi = 0$: WN. $phi = 1$: passeio aleatório (não estacionário). $phi < 0$: ACF oscila. $|phi| > 1$: explosivo.

*AR($p$):* $Y_t = phi_1 Y_(t-1) + dots + phi_p Y_(t-p) + epsilon_t$, ou $phi(B) Y_t = epsilon_t$ com $phi(z) = 1 - phi_1 z - dots - phi_p z^p$.
- *Estacionário $<=>$ todas as raízes de $phi(z) = 0$ têm $|z| > 1$* (fora do círculo unitário). No AR(1): raiz $z = 1/phi$, então $|z| > 1 <=> |phi| < 1$.

*MA($q$):* $Y_t = epsilon_t + theta_1 epsilon_(t-1) + dots + theta_q epsilon_(t-q)$, ou $Y_t = theta(B) epsilon_t$.
- É *sempre* estacionário (soma finita de WN). Exemplo MA(1): $E[Y_t] = 0$, $gamma(0) = sigma^2 (1 + theta^2)$, $gamma(1) = theta sigma^2$, $gamma(h) = 0$ para $h >= 2$, logo $rho(1) = theta / (1 + theta^2)$ e a ACF *corta* após o lag 1.
- *Invertibilidade:* raízes de $theta(z) = 1 + theta_1 z + dots + theta_q z^q$ com $|z| > 1$ (MA(1): $|theta| < 1$). Permite escrever o MA como AR($infinity$).

*ARMA($p,q$):* $phi(B) Y_t = theta(B) epsilon_t$ (parte AR precisa ser estacionária, parte MA invertível).

#divider()

== 8. Baselines, previsão e erro

Notação: $hat(y)_(T+h|T)$ é a previsão feita em $T$ para $h$ passos à frente.

#table(
  columns: (auto, auto, auto),
  align: left,
  [*Método*], [*Previsão*], [*Desvio $hat(sigma)_h$ do erro*],
  [Média], [$overline(y)$], [$hat(sigma) sqrt(1 + 1/T)$],
  [Ingênuo (naive)], [$y_T$ (não depende de $h$)], [$hat(sigma) sqrt(h)$],
  [Ingênuo sazonal], [$y_(T+h-m(k+1))$, $k = floor((h-1)/m)$], [$hat(sigma) sqrt(k+1)$],
  [Deriva (drift)], [$y_T + h dot (y_T - y_1)/(T-1)$], [$hat(sigma) sqrt(h(1 + h/T))$],
)

- Exemplo (drift): $y_1 = 10$, $y_T = 20$, $T = 11$, $h = 2$: inclinação $(20-10)/(11-1) = 1$, então $hat(y)_(T+2|T) = 20 + 2 dot 1 = 22$.
- Naive tem $hat(sigma) sqrt(h)$ porque $y_(T+h) - y_T$ é soma de $h$ inovações não correlacionadas (variância $h sigma^2$).
- *Reversão à média:* num estacionário com $rho(h) -> 0$, a previsão linear tende a $mu$ (não ao último valor). Com $d = 1$ (integrado) *não* reverte: fica atrelada ao último nível.
- *Ajustado vs previsão verdadeira:* $hat(y)_t$ (valor ajustado) é previsão *dentro da amostra*; previsão verdadeira é para instante que *não entrou* no ajuste.
- *Resíduo:* $e_t = y_t - hat(y)_t$. $quad hat(sigma)^2 = 1/(T - K) sum_t e_t^2$, com $K$ = nº de parâmetros estimados.

*Diagnóstico de resíduos:*
- *Essencial:* média $approx 0$ e *não correlacionados* (sem memória).
- *Desejável:* variância constante e normalidade (só afetam os intervalos).
- *Box–Pierce:* $Q = n sum_(k=1)^ell r_k^2$. *Ljung–Box:* $Q^* = n(n+2) sum_(k=1)^ell r_k^2 / (n - k)$. Sob $H_0$ (resíduos WN), $Q approx chi^2$ com $ell - K$ graus de liberdade ($K$ = nº de parâmetros ARMA estimados).
- p-valor *pequeno* rejeita $H_0$: sobrou autocorrelação. p-valor alto é bom sinal, mas não é "requisito absoluto".

*Intervalos e bootstrap:*
- Intervalo de 95%: $hat(y)_(T+h|T) plus.minus 1.96 hat(sigma)_h$ (assume erros aproximadamente normais).
- *Bootstrap:* reamostra os resíduos (i.i.d.) para simular trajetórias futuras. Só faz sentido se os resíduos são não correlacionados. Se sobrou memória, o bootstrap *não* corrige o modelo; primeiro modelar a dependência.

#divider()

== 9. Métricas de erro

Seja $e_t = y_t - hat(y)_t$ o erro na janela de teste ($h$ = número de pontos).

- *MAE* $= 1/h sum |e_t|$ (mesma unidade da série).
- *RMSE* $= sqrt(1/h sum e_t^2)$ (pune mais erros grandes).
- *MAPE* $= 100/h sum |e_t / y_t|$. Adimensional, mas *explode ou fica indefinido se $y_t approx 0$* e é *assimétrico*: com $y = 100$ e $hat(y) = 150$ dá $50%$; com $y = 150$ e $hat(y) = 100$ dá $33%$ (penaliza mais superestimar).
- *MASE* $= "MAE"_"teste" / "MAE"_"naive, treino"$, com o denominador dado por

$ (1/(T-1)) sum_(t=2)^T |y_t - y_(t-1)| quad ("sazonal: " |y_t - y_(t-m)|) $

  Escala-livre, funciona com zeros. $"MASE" < 1$: o método errou menos que o naive de referência (cujo erro é medido no *treino*).
- *Escore de Winkler* (intervalo $[l, u]$ de nível $1 - alpha$, *menor é melhor*):

$ W_alpha = cases(
  (u - l) + 2/alpha (l - y) & "se " y < l,
  (u - l) & "se " l <= y <= u,
  (u - l) + 2/alpha (y - u) & "se " y > u
) $

  Dentro do intervalo paga só a *largura*; fora, largura mais multa $2/alpha$ vezes a distância ao extremo violado. Balanceia cobertura e largura (95%: $2/alpha = 40$).

#divider()

== 10. Transformações e diferenciação

- *Box–Cox* estabiliza a *variância*; *diferenciar* estabiliza a *média*. Ordem usual: *Box–Cox primeiro, diferenciar depois*.
- $d$ = nº de diferenças regulares ($(1-B)^d$), $D$ = nº de diferenças sazonais ($(1-B^m)^D$).
- Expansão de $(1-B)(1-B^m) y_t$:

$ (1-B)(1-B^m) y_t = y_t - y_(t-1) - y_(t-m) + y_(t-m-1) $

#divider()

== 11. ARIMA e SARIMA

*ARIMA($p,d,q$):* $phi(B) (1-B)^d y_t = c + theta(B) epsilon_t$. Ou seja, diferenciar $d$ vezes e ajustar um ARMA($p,q$).

- ARIMA(0,0,0) $=$ ruído branco (com média $c$).
- ARIMA(0,1,0) com $c = 0$ $=$ *passeio aleatório*; com $c != 0$ $=$ *passeio com deriva*.
- ARIMA(1,0,0) $=$ AR(1). ARIMA(0,0,1) $=$ MA(1).
- Com $d = 1$ a previsão de longo prazo *não* reverte à média.

*SARIMA*$(p,d,q)(P,D,Q)_m$:

$ Phi(B^m) phi(B) (1-B)^d (1-B^m)^D y_t = c + Theta(B^m) theta(B) epsilon_t $

- $m$ vem do *calendário/frequência* (12, 4, 7, ...), *não* é estimado por AIC.
- Ciclo forte: *diferença sazonal ($D$) primeiro*; depois veja se ainda falta $d$. $d$ e $D$ são decididos por *estacionariedade/diagnóstico*, não por AIC.

*Procedimento de identificação (Box–Jenkins):*
+ Gráfico e Box–Cox se a variância crescer com o nível.
+ Diferenciar até parecer estacionário. *KPSS (nível):* $H_0$ = série *estacionária em nível*; p-valor pequeno rejeita, então diferencie. (ADF é o contrário: $H_0$ = raiz unitária.)
+ Olhar ACF/PACF (tabela da seção 6). Se ambas *decaem* sem corte limpo: tratar como ARMA($p,q$) e escolher $p,q$ por AICc *com o mesmo $d$*.
+ Ajustar candidatos e comparar por *AIC/AICc* (menor melhor).
+ Checar resíduos (Ljung–Box, ACF dos resíduos).

*AIC/AICc:* $"AIC" = -2 log L + 2 k$; o AICc corrige para amostra pequena. Só compara modelos com *mesmo $d$ (e $D$) e mesma transformação*, porque com $d$ diferentes a verossimilhança é calculada sobre dados diferentes. Logo *não* serve para escolher $d$.

#divider()

== 12. Armadilhas recorrentes (V–F)

- Ordem no tempo é *fundamental*; nunca embaralhar para validar.
- Estacionariedade fraca $eq.not$ sem memória (AR(1) é estacionário e tem memória).
- WN $eq.not$ IID. Sair das bandas da ACF $eq.not$ não-estacionário.
- Valor ajustado $eq.not$ previsão verdadeira. Resíduo $eq.not$ erro de previsão a $h$ passos.
- Naive: a previsão *não depende de $h$*. Média: previsão constante $overline(y)$.
- Resíduos com memória: bootstrap i.i.d. não conserta.
- Escolha de $d$, $D$ e $m$ *não* é por AIC.
- Passeio aleatório é não estacionário (variância $t sigma^2$); tendência linear falha na *média*.

]

#collapsible(summary: "Comentários da Lista A1")[

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


#collapsible(summary: "Anotações A2", open: false)[

ljung-box no arima: recap

arima e sarima

OLS

Sazonalidade fixa ou estocástica

Efeito sazonal fixo

Janela deslizante




]
