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
    public static func getAllCardapios() -> [Cardapio] {
        return UnicampServer.getAllCardapios()
    }
    
   
}

// Metodos para o Widget.
extension CardapioServices {
    
    
    /// Faz os calculos e analisa dados (como dieta do usuario) para decidir qual o tipo de refeicao a ser exibida.
    ///
    /// - Parameter dataCardapio: data do cardapio a ser exibido.
    /// - Returns: valor do tipo TipoRefeicao, que informa qual a refeicao que deve ser exibida.
    private static func getTipoRefeicaoParaExibir(dataCardapio: Date) -> TipoRefeicao {
        let horaAtual = Calendar.current.component(.hour, from: Date())
        let diaDaSemanaAtual = Calendar.current.component(.weekday, from: Date())
        
        let (almoco, jantar): (TipoRefeicao,TipoRefeicao) = UserDefaults(suiteName: "group.bandex.shared")!.bool(forKey: "vegetariano") ? (.almocoVegetariano, .jantarVegetariano) : (.almoco, .jantar)
        
        if (2...6).contains(diaDaSemanaAtual) {
            if (14...20).contains(horaAtual) {
                return jantar
            } else {
                return almoco
            }
        } else {
            return almoco
        }
    }
    
    
    /// Metodo que informa se o cardapio a ser exibido deve ser do proximo dia util. Utilizado para mostrar o cardapio do proximo dia quando já tiver passado o jantar do dia atual.
    ///
    /// - Returns: true se for para usar o cardapio do proximo dia util.
    private static func usarCardapioDoProximoDia() -> Bool {
        let hora = Calendar.current.component(.hour, from: Date())
        let weekday = Calendar.current.component(.weekday, from: Date())
        
        return (hora > 19) && (2...6).contains(weekday) ? true : false
    }
    
    
    /// Retorna o proximo cardapio para ser exibido no Widget.
    ///
    /// - Returns: proximo cardapio a ser exibido.
    private static func getProximoCardapio() -> Cardapio? {
        let numeroCardapio = usarCardapioDoProximoDia() ? 1 : 0
        
        let cardapios = getAllCardapios()
        
        guard cardapios.count > numeroCardapio else {
            print("nao veio nenhum cardapio.")
            return nil
        }
        
        
        return cardapios[numeroCardapio]
    }
    
    
    /// Retorna a refeicao que o widget deve exibir, junto com sua data.
    /// Apos chamar esse metodo, o widget so precisa setar os valores em sua view.
    ///
    /// - Returns: Tupla contendo a refeicao a ser exibida e sua data.
    static func getWidgetRefeicaoData() -> (Refeicao?, Date?) {
        
        let proxCardapio = CardapioServices.getProximoCardapio()
        
        guard let cardapio = proxCardapio else {
            print("nao veio nenhum cardapio.")
            return (nil, nil)
        }
        
        let tipo = CardapioServices.getTipoRefeicaoParaExibir(dataCardapio: cardapio.data)
        return (cardapio[tipo], cardapio.data)
    }

}
