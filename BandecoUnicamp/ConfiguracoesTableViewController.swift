//
//  ConfuiguracoesTableViewController.swift
//  BandecoUnicamp
//
//  Created by Gustavo Avena on 10/06/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit

class ConfiguracoesTableViewController: UITableViewController {
    
    
    @IBOutlet weak var dietaSwitch: UISwitch!
    
    
    // TODO: melhorar posicionamento de labels nas configuracoes. Precisa alinhar...

    override func viewDidLoad() {
        super.viewDidLoad()

        dietaSwitch.isOn = UserDefaults(suiteName: "group.bandex.shared")!.bool(forKey: "vegetariano")
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackScreenView()
    }
    
    @IBAction func dietaValueChanged(_ sender: UISwitch) {
        UserDefaults(suiteName: "group.bandex.shared")!.set(sender.isOn, forKey: "vegetariano")
    }
}

//extension UIViewController {
//    func trackScreenView() {
//        if let tracker = GAI.sharedInstance().defaultTracker {
//            tracker.set(kGAIScreenName, value: NSStringFromClass(type(of: self)))
//            tracker.send(GAIDictionaryBuilder.createScreenView().build() as! [AnyHashable : Any]!)
//        }
//    }
//}
