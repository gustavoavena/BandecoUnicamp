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


public class CardapioServices: NSObject {

    
    /// Fornece um array com os **next** cardapios a partir da data **startDate**.
    ///
    /// - Parameters:
    ///   - date: data inicial.
    ///   - next: quantidade de cardapios desejados a partir da data inicial.
    ///   - completionHandler: completionHandler para acessar o retorno assincronamente.
    public static func getCardapiosBatch(startDate date: Date = Date(), next: Int = 5, completionHandler: @escaping ([Cardapio]) -> Void) {
        // TODO: chamar completion handler asincronamente com NSOperationAlgumaCoisa...
        
        if let cardapios = UnicampServer.getCardapiosBatch(date: date, next: next){
            OperationQueue.main.addOperation {
                completionHandler(cardapios)
            }
        } else {
            print("nao conseguiu pegar cardapios em batch.")
        }
        
    }
    

    

}
