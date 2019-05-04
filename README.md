# Sistema Fuzzy de Conceito de Cliente

## Implementação de um Sistema Especialista Fuzzy para Cálculo de Conceito de Clientes
### Adriel Fco. Darosi
### Charles Pereira
	

#### 1. Introdução
<p align="justify">
Neste relatório será explanada a implementação de um Sistema Especialista Fuzzy utilizando a ferramenta FuzzyClyps. O objetivo do sistema é classificar o cliente de determinado setor, analisando a quantidade que ele compra e a seu percentual de inadimplência com a empresa em determinado período. As variáveis linguísticas de entradas e saídas são demonstradas na tabela abaixo:
</p>


<table>
  <thead>
    <tr>
      <th></th>
      <th colspan='5'>Compra</th>
    </tr>
    <tr>
      <th>Inadimplência</th>
      <th>Baixa</th>
      <th>Média_Baixa</th>
      <th>Média</th>
      <th>Média_Alta</th>
      <th>Alta</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Não_Inadimplente</th>
      <td>Razoável</td>
      <td>Bom</td>
      <td>Ótimo</td>
      <td>Ótimo</td>
      <td>Ótimo</td>
    </tr>
    <tr>
      <th>Pouco_Inadimplente</th>
      <td>Ruim</td>
      <td>Razoável</td>
      <td>Razoável</td>
      <td>Bom</td>
      <td>Bom</td>
    </tr>
    <tr>
      <th>Inadimplente</th>
      <td>Muito_Ruim</td>
      <td>Muito_Ruim</td>
      <td>Ruim</td>
      <td>Razoável</td>
      <td>Razoável</td>
    </tr>
  </tbody>
</table>

###### *Tabela 1. Variáveis linguísticas de acordo com a inadimplência e compra do cliente.*

<p align="justify">
Na primeira coluna estão relacionados os valores referentes ao percentual de inadimplência do cliente, enquanto na primeira linha, estão os valores para determinar a quantidade que o cliente comprou no período analisado. Cruzando os valores do percentual de inadimplência com os de quantidade comprada, temos a classificação do cliente.
</p>

#### 2. Implementação e Testes

<p align="justify">
Para cada variável linguística foi definido um template, que mostraremos a seguir. Para a variável linguística Percentual de Inadimplência teremos duas funções pré-definidas (s e z) e uma trapezoide:
</p>

```
	(deftemplate percent_inadip
		0 100 %_inadimplencia
		(
		(nao_inadip (z 0 25))
		(pouco_inadip (20 0)(25 1)(35 1)(40 0))
		(inadimplente (s 35 40))
		)
	)
```

###### *Figura 1. Template inadimplência.*

<p align="justify">
Na figura 2 temos a demonstração gráfica dos possíveis valores numéricos para a variável linguística inadimplência, de acordo com os parâmetros definidos no seu respectivo template.
</p>

#### ![Figura_1](https://github.com/charlespereirahd/trabalhoiafuzzy/blob/master/img/inadip.JPG "deftemplate inadimplencia")
###### *Figura 2. Demonstração gráfica para os possíveis valores numéricos da inadimplência.*

<p align="justify">
Na figura 3 temos o template compra, onde teremos duas funções pré-definidas (s e z), duas trapezoides, e uma em pi:
</p>

```
	(deftemplate qtde_comprada
		0 10000 quantidade_pares_comprados
		(
		(baixa (z 0 1000))
		(media_baixa (800 0)(1000 1)(2500 1)(3000 0))
		(media (pi 2500 5000))
		(media_alta (6000 0)(6500 1)(8000 1)(8500 0))
		(alta (s 8000 9000))
		)
	)
```

##### *Figura 3. Template compra.*

<p align="justify">
Na figura 4 temos a demonstração gráfico dos possíveis valores numéricos para a variável linguística compra:
</p>

#### ![Figura_4](https://github.com/charlespereirahd/trabalhoiafuzzy/blob/master/img/qtde.JPG "deftemplate compra")
###### *Figura 4. Demonstração gráfica para os possíveis valores numéricos da compra.*

<p align="justify">
Na figura 5 temos o template conceito, onde teremos duas funções pré-definidas (s e z) e três pi:
</p>

```
	(deftemplate conceito
		1 10 conceito_cliente
		(
		(muito_ruim (z 1 3))
		(ruim (pi 2 4))
		(razoavel (pi 2 5))
		(bom (pi 1 7))
		(otimo (s 7 8))
		)
	)
```

##### *Figura 5. Template conceito.*

<p align="justify">
Na figura 6 temos a demonstração gráfica dos possíveis valores numéricos para a variável linguística conceito:
</p>

#### ![Figura_6](https://github.com/charlespereirahd/trabalhoiafuzzy/blob/master/img/conceito.JPG "deftemplate conceito")
###### *Figura 6. Demonstração gráfica para os possíveis valores numéricos do conceito.*

<p align="justify">
As regras que vão definir o conceito do cliente foram codificadas em cinco defrule’s distintos, um para cada variável linguística e conceito do cliente. A utilização da declaração da salience foi a solução adotada para garantir que essas regras fossem executadas antes da regra da defuzzificação.
Na figura 7 temos o código fonte das regras. 
</p>

```
	(defrule rule_muito_ruim
		(declare (salience 10))
		(or(and (percent_inadip inadimplente)(qtde_comprada baixa))
		   (and (percent_inadip inadimplente)(qtde_comprada media_baixa))
		)
		=>
		(assert (conceito muito_ruim))
	)
	
	(defrule rule_ruim
		(declare (salience 10))
		(or(and (percent_inadip inadimplente)(qtde_comprada media))
		   (and (percent_inadip pouco_inadip)(qtde_comprada baixa))
		)
		=>
		(assert (conceito ruim))
	)
	
	(defrule rule_razoavel
		(declare (salience 10))
		(or(and (percent_inadip nao_inadip)(qtde_comprada baixa))
		   (and (percent_inadip pouco_inadip)(qtde_comprada media_baixa))
		   (and (percent_inadip pouco_inadip)(qtde_comprada media))
		   (and (percent_inadip inadimplente)(qtde_comprada media_alta))
		   (and (percent_inadip inadimplente)(qtde_comprada alta))
		)
		=>
		(assert (conceito razoavel))
	)
	
	(defrule rule_bom
		(declare (salience 10))
		(or(and (percent_inadip nao_inadip)(qtde_comprada media_baixa))
		   (and (percent_inadip pouco_inadip)(qtde_comprada media_alta))
		   (and (percent_inadip pouco_inadip)(qtde_comprada alta))
		)
		=>
		(assert (conceito bom))
	)
	
	(defrule rule_otimo
		(declare (salience 10))
		(or(and (percent_inadip nao_inadip)(qtde_comprada media))
		   (and (percent_inadip nao_inadip)(qtde_comprada media_alta))
		   (and (percent_inadip nao_inadip)(qtde_comprada alta))
		)
		=>
		(assert (conceito otimo))
	)
```

##### *Figura 7. Código fonte defrule.*

<p align="justify">
Para a defuzzificação foi criada uma variável global (g_conceito) com a função defglobal, e foi criada uma outra regra (defrule defuzifica) declarada com salience 0, para que dessa forma, ela seja executada após todas as regras dos defrule, para assim, podermos ter o resultado do conceito do cliente.
</p>

```
	(defglobal
		?*g_conceito* = 0
	)
	
	(defrule defuzifica
		(declare (salience 0))
		?v_temp <- (conceito ?)
	=>
		(bind ?*g_conceito* (moment-defuzzify ?v_temp))
		(plot-fuzzy-value t "*" nil nil ?v_temp)
		(retract ?v_temp)
		(printout t "Conceito do cliente: ")
		(printout t ?*g_conceito* crlf)
		(printout t "Fim." crlf)
	)
```

##### *Figura 8. Regra da defuzzificação.*

<p align="justify">
Foi definido uma regra fixa com o deffacts, com a finalidade de testar e obter os valores numéricos relacionados ao resultado para o conceito do cliente. Na figura 9, mostra os valores que foram utilizados para o teste, nas variáveis linguísticas de compra e inadimplência.
</p>

```
	(deffacts fatos
		(percent_inadip nao_inadip)
		(qtde_comprada alta)
	)
```

##### *Figura 9. Definição da regra deffacts.*

<p align="justify">
A figura 10, mostra os resultados do conceito do cliente, baseado na regra deffacts da figura 10. Definindo como o cliente não é inadimplente e a sua compra é alta, ele tem uma pontuação de 8.74.
</p>

#### ![Figura_10](https://github.com/charlespereirahd/trabalhoiafuzzy/blob/master/img/plotagem_resultado.JPG "resultado")
###### *Figura 10. Resultado do Conceito do Cliente*

#### 3. Conclusão

<p align="justify">
Uma implementação como está seria muito bem aplicada junto a outros sistemas, como uma ferramenta por si só, não haveria viabilidade nem aplicações possíveis. Tendo em alvo, como exemplo, um sistema ERP, esta implementação poderia estar diretamente vinculada ao conceito do cliente no próprio cadastro do cliente, onde sempre que for havendo alterações, este conceito iria seguir com as alterações condizentes. Visando outros possíveis módulos de um sistema como este, tais como sugestões para faturamento, ferramentas de faturamento automático e aprovação de pedidos, esta implementação poderia estar aliada ao sistema e ser utilizada como mais uma validação a ser feita, pré-definindo a partir de qual conceito o pedido poderia ser aprovado ou faturado, e também até qual período anterior analisar.
</p>
