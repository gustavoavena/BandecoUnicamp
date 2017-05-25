//
//  CardapioHandler.swift
//  BandecoUnicamp
//
//  Created by Gustavo Avena on 215//17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit

class CardapioRequest: NSObject {
	
	static let urlTemplateDevelopment = "http://127.0.0.1:5000/date/"
	static let urlTemplateProduction = "" // TODO
	
	public static func getCardapio(date: String, completionHandler: @escaping ([String: Any]?) -> Void) {
		// Note: mandar a variavel date como String ou Date??
		
		let url = URL(string: urlTemplateDevelopment + date)
		URLSession.shared.dataTask(with: url!, completionHandler: {
			(data, response, error) in
			
			
			guard error == nil else {
				print("error")
				OperationQueue.main.addOperation {
					completionHandler(nil)
				}
				return
			}
			
			do{
				let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String : Any]
				
//					print(json)
				
				print((json["Almoço"] as! Dictionary)["arroz_feijao"]!) // Debugging
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


}
