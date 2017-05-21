//
//  Cardapio.swift
//  BandecoUnicamp
//
//  Created by Gustavo Avena on 145//17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit

enum Refeicao: String {
//	case cafeDaManha
	case almoco = "Almoço"
	case almocoVegetariano = "Almoço Vegetariano"
	case jantar = "Jantar"
	case jantarVegetariano = "Jantar Vegetariano"
}


struct Cardapio {
	let refeicao: Refeicao
	let arrozFeijao: String
	let pratoPrincipal: String
	let salada: String
	let sobremesa: String
	let suco: String
	let guarnicao: String
	let observacoes: String
	
	init(refeicao: Refeicao, arrozFeijao: String, pratoPrincipal: String, salada: String, sobremesa: String, suco: String, guarnicao: String, observacoes: String) {
		self.refeicao = refeicao
		self.arrozFeijao = arrozFeijao
		self.pratoPrincipal = pratoPrincipal
		self.salada = salada
		self.sobremesa = sobremesa
		self.suco = suco
		self.guarnicao = guarnicao
		self.observacoes = observacoes
	}

}
