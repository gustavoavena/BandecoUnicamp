//
//  CardapioHandler.swift
//  BandecoUnicamp
//
//  Created by Gustavo Avena on 215//17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit

class CardapioHandler: NSObject {
	
	public static func getCardapio(date: String, completionHandler: @escaping ([String: Any]?) -> Void) {
		
		let url = URL(string: "http://127.0.0.1:5000/date/\(date)")
		URLSession.shared.dataTask(with: url!, completionHandler: {
			(data, response, error) in
			if(error != nil){
				print("error")
				OperationQueue.main.addOperation {
					completionHandler(nil)
				}
				completionHandler(nil)
			}else{
				do{
					let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String : Any]
					
//					print(json)
					
					print((json["Almoço"] as! Dictionary)["arroz_feijao"]!)
					OperationQueue.main.addOperation {
						completionHandler(json)
					}
					
					
				}catch let error as NSError{
					print(error)
					OperationQueue.main.addOperation {
						completionHandler(nil)
					}
				}
			}
		}).resume()
	}


}
