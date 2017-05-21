//
//  Cardapio.swift
//  BandecoUnicamp
//
//  Created by Gustavo Avena on 145//17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit

enum Refeicao {
//	case cafeDaManha
	case almoco
	case almocoVegetariano
	case jantar
	case jantarVegetariano
}

enum Arroz {
	case normal
	case integral
}

struct Cardapio {
	let refeicao: Refeicao
	let arroz: Arroz
	let pratoPrincipal: String
	let salada: String
	let sobremesa: String
	let suco: String
	let guarnicao: String
	let observacoes: String
	
	init(refeicao: Refeicao, arroz: Arroz, pratoPrincipal: String, salada: String, sobremesa: String, suco: String, guarnicao: String, observacoes: String, arrozFeijao: String?) {
		self.refeicao = refeicao
		self.arroz = arroz
		self.pratoPrincipal = pratoPrincipal
		self.salada = salada
		self.sobremesa = sobremesa
		self.suco = suco
		self.guarnicao = guarnicao
		self.observacoes = observacoes
	}

}
