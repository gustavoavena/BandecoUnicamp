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
public class Cardapio: Gloss.JSONDecodable {
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


