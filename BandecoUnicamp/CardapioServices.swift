//
//  CardapioServices.swift
//  BandecoUnicamp
//
//  Created by Gustavo Avena on 215//17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit

enum JSONKeys: String {
    case arrozFeijao = "arroz_feijao"
    case salada = "salada"
    case suco = "suco"
    case pratoPrincipal = "prato_principal"
    case sobremesa = "sobremesa"
    case observacoes = "observacoes"
}

enum Refeicoes: String {
    case almoco = "Almoço"
    case almocoVegetariano = "Almoço Vegetariano"
    case jantar = "Jantar"
    case jantarVegetariano = "Jantar Vegetariano"
}

public class CardapioServices: NSObject {
	
	static let urlTemplateDevelopment = "http://127.0.0.1:5000/date/"
	static let urlTemplateProduction = "" // TODO
	
	public static func getCardapio(date: Date, completionHandler: @escaping ([String: Any]?) -> Void) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)

		let url = URL(string: urlTemplateDevelopment + dateString)

        
		URLSession.shared.dataTask(with: url!, completionHandler: {
			(data, response, error) in
			
			guard error == nil, let data = data else {
				print("Erro no request.")
                print("error: \(String(describing: error))\n\n")
				OperationQueue.main.addOperation {
					completionHandler(nil)
				}
				return
			}
            
			do{
				let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
				
//                print(json)
				
				OperationQueue.main.addOperation {
					completionHandler(json)
				}
				
			} catch let error as NSError{
				print(error)
				OperationQueue.main.addOperation {
					completionHandler(nil)
				}
			}
			
		}).resume()
	}
    
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


}
