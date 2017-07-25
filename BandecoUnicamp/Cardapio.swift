//
//  Cardapio.swift
//  BandecoUnicamp
//
//  Created by Gustavo Avena on 145//17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit
import Gloss



/// Utilizado ** bastante ** durante o codigo. Tem valores string padrao para facilitar a exibicao na view e padronizar as chaves do JSON que recebemos.
public enum TipoRefeicao: String {
    case almoco = "Almoço"
    case almocoVegetariano = "Almoço vegetariano"
    case jantar = "Jantar"
    case jantarVegetariano = "Jantar vegetariano"
}

enum JSONKeys: String {
    case arrozFeijao = "arroz_feijao"
    case salada = "salada"
    case suco = "suco"
    case pratoPrincipal = "prato_principal"
    case sobremesa = "sobremesa"
    case observacoes = "observacoes"
    case guarnicao = "guarnicao"
    case pts = "pts"
    case tipo = "tipo"
    case almoco = "almoco"
    case almocoVegetariano = "almoco_vegetariano"
    case jantar = "jantar"
    case jantarVegetariano = "jantar_vegetariano"
    
    
}

// TODO: implementar equatable protocol.

/// Mantem o cardapio de todas as refeicoes de um dia.
public class Cardapio: Decodable {
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
    
    
    
    public required init?(json: JSON) {
        
        guard let dataString: String = "data" <~~ json,
            let almoco: Refeicao = JSONKeys.almoco.rawValue <~~ json,
            let almocoVegetariano: Refeicao = JSONKeys.almocoVegetariano.rawValue <~~ json,
            let jantar: Refeicao = JSONKeys.jantar.rawValue <~~ json,
            let jantarVegetariano: Refeicao = JSONKeys.jantarVegetariano.rawValue <~~ json else {
            print("problema deserializando o JSON cardapio")
            return nil
        }
        
        self.almoco = almoco
        self.almocoVegetariano = almocoVegetariano
        self.jantar = jantar
        self.jantarVegetariano = jantarVegetariano
        
       
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let data = dateFormatter.date(from:dataString) else {
            print("problema pegando a data")
            return nil
        }
        
        self.data = data
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


public struct Refeicao: Decodable {
	let tipo: TipoRefeicao
	let arrozFeijao: String
	let pratoPrincipal: String
    let guarnicao: String
    let pts: String
	let salada: String
	let sobremesa: String
	let suco: String
    let observacoes: String
	
    init(tipo: TipoRefeicao, arrozFeijao: String, pratoPrincipal: String, guarnicao: String, pts: String, salada: String, sobremesa: String, suco: String, observacoes: String) {
		self.tipo = tipo
		self.arrozFeijao = arrozFeijao
		self.pratoPrincipal = pratoPrincipal
        self.guarnicao = guarnicao
        self.pts = pts
		self.salada = salada
		self.sobremesa = sobremesa
		self.suco = suco
        self.observacoes = observacoes
	}
    
    public init?(json: JSON) {
        guard let pratoPrincipal: String = JSONKeys.pratoPrincipal.rawValue <~~ json,
            let arrozFeijao: String = JSONKeys.arrozFeijao.rawValue <~~ json,
            let guarnicao: String = JSONKeys.guarnicao.rawValue <~~ json,
            let pts: String = JSONKeys.pts.rawValue <~~ json,
            let salada: String = JSONKeys.salada.rawValue <~~ json,
            let suco: String = JSONKeys.suco.rawValue <~~ json,
            let observacoes: String = JSONKeys.observacoes.rawValue <~~ json,
            let sobremesa: String = JSONKeys.sobremesa.rawValue <~~ json,
            let tipo: String = JSONKeys.tipo.rawValue <~~ json else {
                print("problema deserializando o JSON refeicao")
                return nil
        }
        
        self.pratoPrincipal = pratoPrincipal
        self.guarnicao = guarnicao
        self.pts = pts
        self.salada = salada
        self.sobremesa = sobremesa
        self.suco = suco
        self.observacoes = observacoes
        self.arrozFeijao = arrozFeijao
        
        
        switch tipo {
        case TipoRefeicao.almoco.rawValue:
            self.tipo = .almoco
        case TipoRefeicao.jantar.rawValue:
            self.tipo = .jantar
        case TipoRefeicao.almocoVegetariano.rawValue:
            self.tipo = .almocoVegetariano
        case TipoRefeicao.jantarVegetariano.rawValue:
            self.tipo = .jantarVegetariano
        default:
            print("nao reconheceu o tipo da refeicao")
            self.tipo = .almoco
        }
        
    }

}
