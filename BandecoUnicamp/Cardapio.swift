//
//  Cardapio.swift
//  BandecoUnicamp
//
//  Created by Gustavo Avena on 145//17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit


/// Utilizado ** bastante ** durante o codigo. Tem valores string padrao para facilitar a exibicao na view e padronizar as chaves do JSON que recebemos.
public enum TipoRefeicao: String {
    case almoco = "Almoço"
    case almocoVegetariano = "Almoço Vegetariano"
    case jantar = "Jantar"
    case jantarVegetariano = "Jantar Vegetariano"
}


/// Mantem o cardapio de todas as refeicoes de um dia.
public class CardapioDia {
    let data: Date
    let almoco: Refeicao
    let jantar: Refeicao
    let almocoVegetariano: Refeicao
    let jantarVegetariano: Refeicao
    
    init(data: Date, almoco: Refeicao, jantar: Refeicao, almocoVegetariano: Refeicao, jantarVegetariano: Refeicao) {
        self.data = data
        self.almoco = almoco
        self.jantar = jantar
        self.almocoVegetariano = almocoVegetariano
        self.jantarVegetariano = jantarVegetariano
    }
    
    
    convenience init(data: Date, cardapioRefeicoes refs: [TipoRefeicao: Refeicao]) {
        self.init(data: data, almoco: refs[.almoco]!, jantar: refs[.jantar]!, almocoVegetariano: refs[.almocoVegetariano]!, jantarVegetariano: refs[.jantarVegetariano]!)
    }
    
    
    /// Permite que a gente utilize subscripts para referenciar propriedades do objeto.
    ///
    /// - Parameter refeicao: refeicao passada no subscript (e.g. cardapioDia[.almoco]).
    subscript(refeicao: TipoRefeicao) -> Refeicao {
        get {
            switch refeicao {
            case .almoco:
                return self.almoco
            case .jantar:
                return self.jantar
            case .almocoVegetariano:
                return self.almocoVegetariano
            case .jantarVegetariano:
                return self.jantarVegetariano
            }
            
        }
    }
}


public struct Refeicao {
	let tipo: TipoRefeicao
//	let arrozFeijao: String
	let pratoPrincipal: String
    let guarnicao: String
    let pts: String
	let salada: String
	let sobremesa: String
	let suco: String
	
    init(tipo: TipoRefeicao, pratoPrincipal: String, guarnicao: String, pts: String, salada: String, sobremesa: String, suco: String, observacoes: String) {
		self.tipo = tipo
//		self.arrozFeijao = arrozFeijao
		self.pratoPrincipal = pratoPrincipal
        self.guarnicao = guarnicao
        self.pts = pts
		self.salada = salada
		self.sobremesa = sobremesa
		self.suco = suco
	}

}
