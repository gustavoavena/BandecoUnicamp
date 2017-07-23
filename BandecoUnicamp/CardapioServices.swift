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


    /// Fornece um array com todos os cardapios, já em objetos da classe Cardapio, fornecidos pelo servidor.
    ///
    /// - Parameter completionHandler: completion handler que irá ser executado e irá utilizar os objetos dos cardapios após eles serem obtidos.
    public static func getAllCardapios(completionHandler: @escaping ([Cardapio]) -> Void) {
        if let cardapios = UnicampServer.getAllCardapios(){
            OperationQueue.main.addOperation {
                completionHandler(cardapios)
            }
        } else {
            print("nao conseguiu pegar cardapios em batch.")
        }
    }

}
