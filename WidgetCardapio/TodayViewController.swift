//
//  TodayViewController.swift
//  WidgetCardapio
//
//  Created by Gustavo Avena on 215//17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit
import NotificationCenter


class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var refeicao: UILabel!
    @IBOutlet weak var pratoPrincipal: UILabel!
    @IBOutlet weak var sobremesa: UILabel!
    @IBOutlet weak var suco: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
//        CardapioServices.getCardapio(date: Date()) {
//            (cardapioResponse) in
//            
//            guard let cardapio = cardapioResponse else {
//                return
//            }
//            
//            if let almoco = (cardapio[Refeicao.almoco.rawValue] as? [String:Any]) {
//                self.refeicao.text = Refeicao.almoco.rawValue
//                if let pratos = (almoco[JSONKeys.pratoPrincipal.rawValue] as? [String]) {
//                    self.pratoPrincipal.text = pratos[0]
//                }
//                self.sobremesa.text = (almoco[JSONKeys.sobremesa.rawValue] as? String) ?? self.sobremesa.text
//                self.suco.text = (almoco[JSONKeys.suco.rawValue] as? String) ?? self.suco.text
//                
//            }
//        }
        
//        completionHandler(NCUpdateResult.newData)
    }
    
}
