;Sistema CLIPS de avaliação de conceito financeiro de cliente por periodo/quantidade pares comprados
	
	(defglobal
		?*g_conceito* = 0
	)
	
;-Templates
	
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

	(deftemplate percent_inadip
		0 100 %_inadimplencia
		(
		(nao_inadip (z 0 25))
		(pouco_inadip (20 0)(25 1)(35 1)(40 0))
		(inadimplente (s 35 40))
		)
	)

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
	
;-Rules
	
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
	
;-Defuzifica
	
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
	
;-Defacts
	(deffacts fatos
		(percent_inadip nao_inadip)
		(qtde_comprada alta)
	)
	
	
;-Plotagem dos Graficos
	;(plot-fuzzy-value t "+*-@#" 0 10000 
	;	(create-fuzzy-value qtde_comprada baixa) 
	;	(create-fuzzy-value qtde_comprada media_baixa) 
	;	(create-fuzzy-value qtde_comprada media)
	;	(create-fuzzy-value qtde_comprada media_alta) 
	;	(create-fuzzy-value qtde_comprada alta)
	;)
	;									
	;(plot-fuzzy-value t "+*-" 0 100 
	;	(create-fuzzy-value percent_inadip nao_inadip) 
	;	(create-fuzzy-value percent_inadip pouco_inadip) 
	;	(create-fuzzy-value percent_inadip inadimplente)
	;)
	;							  
	;(plot-fuzzy-value t "+*-@#" 1 10 
	;	(create-fuzzy-value conceito muito_ruim) 
	;	(create-fuzzy-value conceito ruim) 
	;	(create-fuzzy-value conceito razoavel)
	;	(create-fuzzy-value conceito bom) 
	;	(create-fuzzy-value conceito otimo)
	;)
	

	
	
