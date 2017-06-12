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


class UnicampServer {
    private static let urlCardapioDevelopment = "http://127.0.0.1:5000/cardapios/date/"
    private static let urlCardapioProduction = "https://bandex.herokuapp.com/cardapios/date/"
//    private static let urlTemplateProduction = "" // TODO
    
    
    // - MARK: metodos auxiliares
    
    /// Retorna a string para uma data no formato desejado para o request para o app em Python
    ///
    /// - Parameter date: data que sera utilizada no URL para o request
    /// - Returns: string dessa data no formato yyyy-MM-dd
    private static func urlDateString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    
    /// Retorna um objeto Date a partir de uma string no formato do URL.
    private static func date(from str: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.date(from:str)
    }
    
    
    
    
    // - MARK: metodos principais
    

    
    /// Responsavel por fazer um GET request sincrono para o app em Python, que retorna um JSON com o cardapio da data fornecida.
    /// Esse metodo faz o request para o cardapio de **um dia***.
    /// - Parameter date: data do cardapio que deve ser retornado.
    /// - Returns: dicionario do JSON parseado no formato [String: Any]
    private static func getCardapioJSON(date: Date) -> [String: Any] {
        
        let dateString = UnicampServer.urlDateString(date: date)
        let url = URL(string: urlCardapioProduction + dateString)
        var json: [String: Any] = [String: Any]()
        
        URLSession.shared.sendSynchronousRequest(request: url!) {
            (data, response, error) in
            
            guard error == nil, let data = data else {
                print("Erro no request.")
                print("error: \(String(describing: error))\n\n")
                return
            }
            
            do{
                json = try JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
                
            } catch let error as NSError{
                print(error)
            }
        }
        
        return json
    }

    
    // - MARK: Metodos publicos. Entrypoints onde podem ser requisitados cardapios, em batch ou nao.
    
    /// Retorna o cardapio ** do dia todo ** (todas as refeicoes) para uma dada data.
    ///
    /// - Parameter date: data do cardapio desejado
    /// - Returns: Objeto do tipo Cardapio que contem todos os cardapios daquele dia.
    public static func getCardapio(date: Date) -> Cardapio? {
        
        let json = getCardapioJSON(date: date)
        
//        return jsonToCardapio(date: date, json: json)
        return Cardapio(json: json)
    }

    
    
    /// Esse eh o metodo mais importante. Ele recebe um array de datas e retorna um array com os objetos Cardapio dessas datas.
    /// Para isto, ele executa um POST request para o app em Flask, que processa as datas e retorna um JSON com todos os cardapios de uma vez.
    ///
    /// - Parameter dates: array de objetos Date, com as datas dos cardapios a serem consultados.
    /// - Returns: array de objetos Cardapio com os cardapios ou nil.
    public static func getCardapiosBatch(date: Date, next: Int) -> [Cardapio]? {
        
        let dateString = UnicampServer.urlDateString(date: date)
        let url = URL(string: urlCardapioProduction + "\(dateString)/next/\(next)")
        var json = [Any]()
        
        
        // TODO: criar outro metodo e reutilizar esse codigo do getCardapioJSON
        URLSession.shared.sendSynchronousRequest(request: url!) {
            (data, response, error) in
            
            guard error == nil, let data = data else {
                print("Erro no request.")
                print("error: \(String(describing: error))\n\n")
                return
            }
            
            
            do{
                json = try JSONSerialization.jsonObject(with: data, options: []) as! [Any]
                
//                print("json = \(json)")
            } catch let error as NSError{
                print(error)
            }
        }

        var cardapios = [Cardapio]()
        for value in json {
            if let cardapioJSON = value as? [String: Any] {
                if let c = Cardapio(json: cardapioJSON) {
//                    print(c)
                    cardapios.append(c)
                } else {
                    print("nao conseguiu mapear o objeto")
                }
            } else {
                print("Nao conseguiu fazer cast do cardapioJSON para [String: Any]")
            }
        }
        
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

