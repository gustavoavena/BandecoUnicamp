//
//  ViewController.swift
//  BandecoUnicamp
//
//  Created by Gustavo Avena on 135//17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit
import Fuzi


class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		parseHTML()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func readBundle(file:String) -> String
	{
		var res = ""
		
		if let path = Bundle.main.path(forResource: file, ofType: "html") {
			do {
				let string =  try String(contentsOfFile: path, encoding: .iso2022JP)
				res = string
//				print("res", res)
			} catch let error {
				print("Error when opening file")
				print(error)
			}
			
		}
		return res
	}
	
	
	func parseHTML() {

//		let filePath = Bundle.main.path(forResource: "cardapio", ofType: "html")
		var text: String
		
		text = readBundle(file: "cardapio")
//		print("cardapio text:", text)
		
		do {
			// if encoding is omitted, it defaults to NSUTF8StringEncoding
			let doc = try HTMLDocument(string: text, encoding: String.Encoding.utf8)
			
			// CSS queries
			if let elementById = doc.firstChild(css: "#id") {
				print(elementById.stringValue)
			}
//			for link in doc.css("a, link") {
//				print(link.rawXML)
//				print(link["href"])
//			}
			
			// XPath queries
			
			let cardapio = doc.css(".fundo_cardapio")
			print(cardapio.count)
			
			for meal in cardapio {
				print("meal: ", meal)
			}
			
			if let firstAnchor = doc.firstChild(xpath: "//table/tr/td/table") {
//				print(firstAnchor.attributes)
				let meals = firstAnchor.children(tag: "tr")[3].children(tag: "td")
				print(meals)
				
			}
			
			
			/*
			//table/tr/td/table/tr[3]/td[0] -> almoco
			//table/tr/td/table/tr[3]/td[1] -> almoco vegetariano
			//table/tr/td/table/tr[3]/td[2] -> jantar
			//table/tr/td/table/tr[3]/td[3] -> jantar vegetariano
			
			
			*/
//			for script in doc.xpath("//head/script") {
//				print(script["src"])
//			}
//			
//			// Evaluate XPath functions
//			if let result = doc.eval(xpath: "count(/*/a)") {
//				print("anchor count : \(result.doubleValue)")
//			}
			
			// Convenient HTML methods
			print(doc.title) // gets <title>'s innerHTML in <head>
//			print(doc.head)  // gets <head> element
//			print(doc.body)  // gets <body> element
					// you can also use CSS selector against XMLDocument when you feels it makes sense
		} catch let error as XMLError {
			switch error {
				case .noError: print("wth this should not appear")
				case .parserFailure, .invalidData: print(error)
				case .libXMLError(let code, let message):
				print("libxml error code: \(code), message: \(message)")
			
			}
		
		} catch {
			print("Unknown error!")
		}
	}


}

