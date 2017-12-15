//
//  Refeicao.swift
//  BandecoUnicamp
//
//  Created by Gustavo Avena on 28/08/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit
import Gloss


public struct Refeicao: Gloss.JSONDecodable {
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

