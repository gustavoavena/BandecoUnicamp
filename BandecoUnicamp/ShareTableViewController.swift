//
//  ShareTableViewController.swift
//  BandecoUnicamp
//
//  Created by Julianny Favinha on 9/28/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit

class ShareTableViewController: CardapioTableViewController {
    
    @IBOutlet var footer: UIView!
    
    var sizeToCrop:CGSize = CGSize(width: 0, height: 0)
    
    var type: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setCardapio(cardapio: Cardapio, vegetariano: Bool) {
        self.cardapio = cardapio
        self.dateLabel.text = formatDateString(data: cardapio.data)
        
        let almoco = vegetariano ? cardapio.almocoVegetariano : cardapio.almoco
        let jantar = vegetariano ? cardapio.jantarVegetariano : cardapio.jantar
        
        let ref = self.screenshotAlmoco ? almoco : jantar

        pratoPrincipalAlmoco.text = ref.pratoPrincipal
        sobremesaAlmoco.text = ref.sobremesa
        sucoAlmoco.text = ref.suco
        guarnicaoAlmoco.text = ref.guarnicao
        ptsAlmoco.text = ref.pts
        saladaAlmoco.text = ref.salada
    }
}

extension ShareTableViewController {
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if type == "Jantar" {
            return "JANTAR"
        }
        
        return "ALMOÇO"
    }
}
