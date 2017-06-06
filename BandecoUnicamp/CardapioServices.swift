//
//  CardapioServices.swift
//  BandecoUnicamp
//
//  Created by Gustavo Avena on 215//17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//





/*
    Essa classe contem a logica do app.
 Ela pega o conteudo do UnicampServer já em formato de objeto (Cardapio)
 
 */

import UIKit

enum JSONKeys: String {
    case arrozFeijao = "arroz_feijao"
    case salada = "salada"
    case suco = "suco"
    case pratoPrincipal = "prato_principal"
    case sobremesa = "sobremesa"
    case observacoes = "observacoes"
}


public class CardapioServices: NSObject {
	
    
    
    /// Dada uma data, ela retorna as proximas next datas de dias uteis (dias que o bandeco esta aberto) em um array.
    ///
    /// - Parameter next: quantidade de dias requisitados (e.g. os proximos 7 dias uteis).
    /// - Returns: array de Date objects.
    public static func getDates(next: Int) -> [Date] {
        let DAY_IN_SECONDS:Int = 60 * 60 * 24
        
        var days:[Date] = [Date]()
        
        var counter = 0
        
        while(days.count < next) {
            
            let day = Date(timeIntervalSinceNow: TimeInterval(counter * DAY_IN_SECONDS))
            
            if((2...6).contains(Calendar.current.component(.weekday, from: day))) {

                days.append(day)
            }
            counter += 1
        }
        
        return days
    }
    
  
    
    /// Utiliza o metodo no UnicampServer para pegar os cardapios dos dias passados como parametro.
    /// Depois sera modificado para fazer um request que pede varios de uma vez.
    ///
    /// - Parameters:
    ///   - dates: datas para as quais voce quer o cardapio.
    ///   - completionHandler: completionHandler que sera executado asincronamente na Main thread (no viewController). Ela recebe um array de objetos CardapioDia.
    public static func getCardapios(for dates: [Date], completionHandler: @escaping ([CardapioDia]) -> Void) {
        var cardapios: [CardapioDia] = [CardapioDia]()
        for d in dates {
            if let c = UnicampServer.getCardapioDia(date: d) {
                cardapios.append(c)
            }
        }
        // TODO: chamar completion handler asincronamente com NSOperationAlgumaCoisa...
        
        OperationQueue.main.addOperation {
            completionHandler(cardapios)
        }
    
    }
    
    public static func getCardapiosBulk(for dates: [Date], completionHandler: @escaping ([CardapioDia]) -> Void) {
        let cardapios = UnicampServer.getCardapiosBulk(dates: dates)
        // TODO: chamar completion handler asincronamente com NSOperationAlgumaCoisa...
        
        if let cardapios = cardapios {
            OperationQueue.main.addOperation {
                completionHandler(cardapios)
            }
        } else {
            print("cardapios = nil")
        }
        
    }
    

    

}
