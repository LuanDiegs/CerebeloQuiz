extends Node
class_name Util

func agruparArray(valores: Array):
	var valoresAgrupados: Array
	
	for valor in valores:
		if !valoresAgrupados.has(valor):
			valoresAgrupados.append(valor)
	
	return valoresAgrupados
