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
    @IBOutlet weak var veggieTableViewCell: UITableViewCell!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        dietaSwitch.isOn = UserDefaults(suiteName: "group.bandex.shared")!.bool(forKey: "vegetariano")
        
        // back button color
        self.navigationController?.navigationBar.tintColor = UIColor(red:0.96, green:0.42, blue:0.38, alpha:1.0)
        
        // disable highlight on veggie's cell. its only possible to click on switch
        self.veggieTableViewCell.selectionStyle = .none;
        

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
    
    
    // Abre o feedback form no Safari
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 && indexPath.row == 0 {
            UIApplication.shared.openURL(URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSekvO0HnnfGnk0-FLTX86mVxAOB5Uajq8MPmB0Sv1pXPuQiCg/viewform")!)
        }
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
