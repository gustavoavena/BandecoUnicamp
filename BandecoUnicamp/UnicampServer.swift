//
//  UnicampServer.swift
//  BandecoUnicamp
//
//  Created by Gustavo Avena on 6/1/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

/*
 
 Faz os requests pro app e retorna objetos Cardapio.
 
 NENHUM outro arquivo deve conter qualquer tipom de JSON.
 Todo o resto deve operar objetos do tipo Cardapio, para garantir um desacoplamento.
 
 */


import Foundation
import SwiftyJSON


class UnicampServer {
    private static let urlAllCardapiosDevelopment = "http://127.0.0.1:8000/cardapios"
    private static let urlAllCardapiosProduction = "https://bandex.herokuapp.com/cardapios"
    
    
    /// Responsavel por fazer um GET request sincrono para o app em Python, que retorna um JSON com os cardapios disponiveis.
    ///
    /// - Returns: json no formato [Any]
    private static func getCardapiosJSON() -> JSON {
        //        let url = URL(string: urlAllCardapiosProduction)
        let url = URL(string: "https://bandex-c2f82.firebaseio.com/cardapios.json")
        var json = JSON.null
        
        
        URLSession.shared.sendSynchronousRequest(request: url!) {
            (data, response, error) in
            
            guard error == nil, let res = response as? HTTPURLResponse, let data = data else {
                print("Erro no request.")
                print("error: \(String(describing: error))\n\n")
                return
            }
            
            guard res.statusCode == 200 else {
                print("Response status code diferente de 200! status code = \(res.statusCode)")
                return
            }
            

            json = JSON(data: data)
            if let dataFromString = json.string?.data(using: .utf8, allowLossyConversion: false) {
                json = JSON(data: dataFromString)
            } else {
                print("Nao conseguiu extrair dados da string do JSON.")
            }

        }
        
        return json
    }
    
    
    /// Esse eh o metodo mais importante. Ele se comunica com o servidor (fazendo request diretamente pra ele) e obtem todos os cardapios disponiveis no API da UNICAMP.
    /// Para isto, ele faz um GET request para o servidor em Flask que retorna todos os cardapios disponiveis serializados em JSON.
    /// Apos isso, ele processa o JSON e utilza os construtores implementados com o Gloss para criar objetos Cardapio correspondentes aos dados obtidos no JSON.
    ///
    /// - Returns: array de objetos Cardapio com os cardapios ou nil em caso de erros.
    public static func getAllCardapios() -> [Cardapio] {
        var json: JSON
        
        
        json = getCardapiosJSON()
        

        var cardapios = [Cardapio]()
        
        if let list = json.rawValue as? [[String: Any]] {
            for cardapioJSON in list {
                
                if let c = Cardapio(json: cardapioJSON) { // Utiliza o convenienve init do Gloss para instanciar objetos Cardapio.
//                    print(c)
                    cardapios.append(c)
                } else {
                    print("nao conseguiu mapear o objeto")
                }
            }
        } else {
            print("problema no casting do JSON para [[String: Any]].")
        }
        
        // Filtra os cardapios antigos, caso por algum motivos eles venham do servidor.
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let nowString = formatter.string(from: Date())
        
        cardapios = cardapios.filter { formatter.string(from: $0.data) >= nowString }

        
        return cardapios
    }
    
}


// MARK: - Essa extensao permite que a gente faça requests sincronos.
extension URLSession {
    func sendSynchronousRequest(request: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = self.dataTask(with: request) { (data, response, error) in
            completionHandler(data,response,error)
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
    
    func sendSynchronousURLRequest(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = self.dataTask(with: request) { (data, response, error) in
            completionHandler(data,response,error)
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
    
    func sendAsynchronousRequest(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let task = self.dataTask(with: request) { data, response, error in
            completionHandler(data, response, error)
        }
        task.resume()
        return task
    }
}

