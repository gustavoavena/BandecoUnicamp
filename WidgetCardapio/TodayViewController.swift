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
    
    // TODO: metodo que define qual refeicao sera mostrada no momento (almoco/jantar ou almoco/jantar vegetariano), dependendo da hora e da dieta do usuario.
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        CardapioServices.getCardapios(for: [Date()]){
            (cardapios) in
            
            guard cardapios.count == 1 else {
                return
            }
            let cardapioDia = cardapios[0]
            
            print(cardapioDia)
            
            self.refeicao.text = Refeicao.almoco.rawValue
            self.pratoPrincipal.text = cardapioDia.almoco.pratoPrincipal[0]
            self.sobremesa.text = cardapioDia.almoco.sobremesa
            self.suco.text = cardapioDia.almoco.suco
                
            
        }
        
//        completionHandler(NCUpdateResult.newData)
    }
    
}
