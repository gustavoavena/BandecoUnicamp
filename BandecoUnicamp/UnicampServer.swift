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
    private static let urlTemplateDevelopment = "http://127.0.0.1:5000/date/"
//    private static let urlTemplateProduction = "" // TODO
    private static let postRequestURLDevelopment = "http://127.0.0.1:5000/dates"
    
    
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
    


    
    /// Recebe o cardapio de **uma refeicao** no formato [String: Any] (que veio do JSON e retorna o objeto Cardapio correspondente.
    ///
    /// - Parameters:
    ///   - json: Dicionario com o cardapio dessa refeicao para esta data no formato [String: Any].
    /// - Returns: Optional de um objeto cardapio.
//    static func jsonRefeicaoToCardapio(refeicaoJson json: [String: Any]) -> Refeicao? {
//        
//        guard let arrozFeijao = json[JSONKeys.arrozFeijao.rawValue] as? String,
//            let sobremesa = json[JSONKeys.sobremesa.rawValue] as? String,
//            let salada = json[JSONKeys.salada.rawValue] as? String,
//            let suco = json[JSONKeys.suco.rawValue] as? String,
//            let observacoes = json[JSONKeys.observacoes.rawValue] as? String else {
//                print("problema com o arroz e feijao")
//                return nil
//        }
//        
//        guard let pratos = json[JSONKeys.pratoPrincipal.rawValue] as? [String] else {
//            print("problema com o prato principal no JSON")
//            return nil
//        }
//        
//        return Refeicao(tipo: arrozFeijao, pratoPrincipal: pratos, guarnicao: "Não informado", pts: "teste", salada: salada, sobremesa: sobremesa, suco: suco, observacoes: observacoes)
//    }
//    
    
    
    /// Dado um cardapio de um dia inteiro (4 refeicoes), no formato [String: Any], ele retorna o objeto CardapioDia correspondente.
    ///
    /// - Parameters:
    ///   - date: data do cardapio inteiro.
    ///   - json: json com o cardapio do dia, contendo o cardapio das 4 refeicoes.
    /// - Returns: retorna o objeto CardapioDia correspondente, se for possivel. Caso contrario, retorna nil.
//    private static func jsonToCardapioDia(date: Date, json: [String: Any]) -> CardapioDia? {
//        
//        let refeicoes:[Refeicao] = [.almoco, .almocoVegetariano, .jantar, .jantarVegetariano]
//        
//        var cardapioRefeicoes: [TipoRefeicao:Refeicao] = [TipoRefeicao: Refeicao]()
//        
//        for r in refeicoes {
//            
//            if let cardapio = json[r.rawValue] as? [String: Any] {
//                
//                if let c = jsonRefeicaoToCardapio(refeicaoJson: cardapio) {
//                    
//                    cardapioRefeicoes[r] = c
//                } else {
//                    print("problema mapeando JSON para objeto cardapio")
//                }
//            } else {
//                print("refeicao faltando no cardapio!)")
//            }
//            
//        }
//        
//        guard cardapioRefeicoes.keys.count == 4 else {
//            print("Problema com refeicao da data \(date)")
//            return nil
//        }
//        
//        return CardapioDia(data: date, cardapioRefeicoes: cardapioRefeicoes)
//    }

    
    /// Responsavel por fazer um GET request sincrono para o app em Python, que retorna um JSON com o cardapio da data fornecida.
    /// Esse metodo faz o request para o cardapio de **um dia***.
    /// - Parameter date: data do cardapio que deve ser retornado.
    /// - Returns: dicionario do JSON parseado no formato [String: Any]
    private static func getCardapioJSON(date: Date) -> [String: Any] {
        
        let dateString = UnicampServer.urlDateString(date: date)
        let url = URL(string: urlTemplateDevelopment + dateString)
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
    /// - Returns: Objeto do tipo CardapioDia que contem todos os cardapios daquele dia.
    public static func getCardapioDia(date: Date) -> CardapioDia? {
        
//        let json = getCardapioJSON(date: date)
        
//        return jsonToCardapioDia(date: date, json: json)
        return nil // TODO
    }

    
    
    /// Esse eh o metodo mais importante. Ele recebe um array de datas e retorna um array com os objetos CardapioDia dessas datas.
    /// Para isto, ele executa um POST request para o app em Flask, que processa as datas e retorna um JSON com todos os cardapios de uma vez.
    ///
    /// - Parameter dates: array de objetos Date, com as datas dos cardapios a serem consultados.
    /// - Returns: array de objetos CardapioDia com os cardapios ou nil.
    public static func getCardapiosBulk(dates: [Date]) -> [CardapioDia]? {
        var json = [Any]()
        var datasString:[String] = [String]()

        
        for d in dates {
            datasString.append(urlDateString(date: d))
        }
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: ["datas": datasString], options: []) {
            
            guard let url = URL(string: postRequestURLDevelopment) else {
                print("erro criando URL para POST request")
                return nil
            }
            
            // prepara request object
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            
            // faz um POST request sincronamente para o servidor, mandando as datas dos cardapios desejados.
            URLSession.shared.sendSynchronousURLRequest(request: request, completionHandler: { (data, response, error) in
                
                guard let data = data, error == nil else {
                    print("error=\(error!)")
                    return
                }

                do{
                    json = try JSONSerialization.jsonObject(with: data, options: []) as! [[Any]]
                    
                } catch let error as NSError{
                    print("problema convertendo JSON para [String: Any]")
                    print(error)
                }
            })
            
        } else {
            print("problema serializando o JSON para o request.")
        }
        
        
        var cardapioDias:[CardapioDia] = [CardapioDia]()

        for tuple in json {
            if let tuple = (tuple as? [Any]), let dia = tuple[0] as? String, let cardapioJson = (tuple[1] as? [String: Any])  {
                
                if let data = date(from: dia), let c = jsonToCardapioDia(date: data, json: cardapioJson) {
                    cardapioDias.append(c)
                }
                
            } else {
                print("tupla não esta correta.")
                return nil
            }
        }
        
//        print("cardapioDias = \(cardapioDias)")
        return cardapioDias
    }

    
}


// TODO: alterar o back-end todo e deixar ele RESTful.
// Criar classes la no servidor e usar o "Gloss"? para mapear os VOs para as classes correspondentes aqui.



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

