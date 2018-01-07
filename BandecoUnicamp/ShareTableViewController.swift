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
        self.dateLabel.text = formatarData(data: cardapio.data)
        
        let almoco = vegetariano ? cardapio.almocoVegetariano : cardapio.almoco
        let jantar = vegetariano ? cardapio.jantarVegetariano : cardapio.jantar
        
        let ref = self.screenshotAlmoco ? almoco : jantar
        
        if (!self.screenshotAlmoco) {
            self.tableView.headerView(forSection: 0)?.textLabel?.text = "JANTAR"
            
                print("Não quero mudar!!!")
            print(self.tableView.headerView(forSection: 0)?.textLabel?.text)
        }

        pratoPrincipalAlmoco.text = ref.pratoPrincipal
        sobremesaAlmoco.text = ref.sobremesa
        sucoAlmoco.text = ref.suco
        guarnicaoAlmoco.text = ref.guarnicao
        ptsAlmoco.text = ref.pts
        saladaAlmoco.text = ref.salada
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if ((section == 0) && !self.screenshotAlmoco) {
            if let header = view as? UITableViewHeaderFooterView {
                header.textLabel?.text = "JANTAR"
            }
        }
    }
}
