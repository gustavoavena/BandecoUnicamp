//
//  ViewController.swift
//  BandecoUnicamp
//
//  Created by Gustavo Avena on 135//17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
//		parseJSON()
	}

	
	func readBundle(file:String) -> String
	{
		var res = ""
		
		if let path = Bundle.main.path(forResource: file, ofType: "") {
			do {
				let string =  try String(contentsOfFile: path, encoding: .utf8)
				res = string
//				print("res", res)
			} catch let error {
				print("Error when opening file")
				print(error)
			}
			
		}
		return res
	}
	
	func convertToDictionary(text: String) -> [String: Any]? {
		if let data = text.data(using: .utf8) {
			print(data)
			do {
				return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
			} catch {
				print("Error reading JSON")
				print(error.localizedDescription)
			}
		}
		
		print("couldn't extract data from text")
		return nil
	}
	
	
	func parseJSON() {
		
		let url = URL(string: "http://127.0.0.1:5000/date/2017-05-23")
		URLSession.shared.dataTask(with: url!, completionHandler: {
			(data, response, error) in
			if(error != nil){
				print("error")
			}else{
				do{
					let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String : Any]
					
					print(json)
					
					print((json["Almoço"] as! Dictionary)["arroz_feijao"]!)
					
					
				}catch let error as NSError{
					print(error)
				}
			}
		}).resume()
	}
	
	

}

