//
//  Cardapio.swift
//  BandecoUnicamp
//
//  Created by Gustavo Avena on 145//17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit




public struct Cardapio {
	let refeicao: Refeicao
	let arrozFeijao: String
	let pratoPrincipal: [String]
	let salada: String
	let sobremesa: String
	let suco: String
//	let guarnicao: String
	let observacoes: String
    let date: Date
	
    init(refeicao: Refeicao, arrozFeijao: String, pratoPrincipal: [String], salada: String, sobremesa: String, suco: String, observacoes: String, date: Date) {
		self.refeicao = refeicao
		self.arrozFeijao = arrozFeijao
		self.pratoPrincipal = pratoPrincipal
		self.salada = salada
		self.sobremesa = sobremesa
		self.suco = suco
//		self.guarnicao = guarnicao
		self.observacoes = observacoes
        self.date = date
	}

}
