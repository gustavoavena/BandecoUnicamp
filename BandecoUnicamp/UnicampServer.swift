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
    
    
    
    /// Retorna a string para uma data no formato desejado para o request para o app em Python
    ///
    /// - Parameter date: data que sera utilizada no URL para o request
    /// - Returns: string dessa data no formato yyyy-MM-dd
    private static func urlDateString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    
    
    /// Responsavel por fazer o request sincrono para o app em Python e retornar o JSON em formato de dicionario
    ///
    /// - Parameter date: data do cardapio que deve ser buscado
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
    
    
    /// Retorna o cardapio **do dia todo** (todas as refeicoes) para uma dada data.
    ///
    /// - Parameter date: data do cardapio desejado
    /// - Returns: Dicionario que guarda o cardapio de cada refeicao para aquele dia.
    public static func getCardapio(date: Date) -> [Refeicao: Cardapio] {
        
        let json = getCardapioJSON(date: date)
        
        
        // TODO: transformar JSON em objeto Cardapio
        
        var cardapioDoDia: [Refeicao: Cardapio] = [Refeicao: Cardapio]()
        
        
        let refeicoes:[Refeicao] = [.almoco, .almocoVegetariano, .jantar, .jantarVegetariano]
        
        for r in refeicoes {
            if let cardapio = json[r.rawValue] as? [String: Any] {
                if let c = jsonToCardapio(refeicao: r, date: date, json: cardapio) {
                    cardapioDoDia[r] = c
                } else {
                    print("problema mapeando JSON para objeto cardapio")
                }
            } else {
                print("refeicao faltando no cardapio!")
            }
        }
        
        return cardapioDoDia
    }
    
    
    
    /// Recebe o cardapio de **uma** refeicao no formato [String: Any] (que veio do JSON parseado)
    /// e retorna o objeto Cardapio correspondente.
    ///
    /// - Parameters:
    ///   - refeicao: refeicao a qual esse cardapio pertence (e.g. almoco, jantar, almoco vegetariano). Tipo enum Refeicao.
    ///   - date: data desse cardapio.
    ///   - json: Dicionario com o cardapio dessa refeicao para esta data no formato [String: Any].
    /// - Returns: Optional de um objeto cardapio.
    static func jsonToCardapio(refeicao: Refeicao, date: Date, json: [String: Any]) -> Cardapio? {
        
        guard let arrozFeijao = json[JSONKeys.arrozFeijao.rawValue] as? String,
            let sobremesa = json[JSONKeys.sobremesa.rawValue] as? String,
            let salada = json[JSONKeys.salada.rawValue] as? String,
            let suco = json[JSONKeys.suco.rawValue] as? String,
            let observacoes = json[JSONKeys.observacoes.rawValue] as? String else {
                print("problema com o arroz e feijao")
                return nil
    
        }

        guard let pratos = json[JSONKeys.pratoPrincipal.rawValue] as? [String] else {
            print("problema com o prato principal no JSON")
            return nil
        }
        
        return Cardapio(refeicao: refeicao, arrozFeijao: arrozFeijao, pratoPrincipal: pratos,
                        salada: salada, sobremesa: sobremesa, suco: suco, observacoes: observacoes, date: date)
    }
    
    // TODO: metodo que faz um POST request do cardapio de multiplas datas.

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
    
    func sendAsynchronousRequest(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let task = self.dataTask(with: request) { data, response, error in
            completionHandler(data, response, error)
        }
        task.resume()
        return task
    }
}

