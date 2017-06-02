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

public enum Refeicao: String {
    case almoco = "Almoço"
    case almocoVegetariano = "Almoço Vegetariano"
    case jantar = "Jantar"
    case jantarVegetariano = "Jantar Vegetariano"
}

public class CardapioServices: NSObject {
	
    
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
    
  
    public static func getCardapios(for dates: [Date], completionHandler: @escaping ([Cardapio]?) -> Void) {
        
        
        // TODO: chamar completion handler asincronamente com NSOperationAlgumaCoisa...
    
    }
    

    

}
