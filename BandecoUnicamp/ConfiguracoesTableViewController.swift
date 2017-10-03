//
//  ConfuiguracoesTableViewController.swift
//  BandecoUnicamp
//
//  Created by Gustavo Avena on 10/06/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit
import UserNotifications

class ConfiguracoesTableViewController: UITableViewController {
    
    
    @IBOutlet weak var dietaSwitch: UISwitch!
    @IBOutlet weak var veggieTableViewCell: UITableViewCell!
    @IBOutlet weak var notificationSwitch: UISwitch!
    
  
    
    
    let notificationsUserDefaultsString = "notificationsEnabled"
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dietaSwitch.isOn = UserDefaults(suiteName: "group.bandex.shared")!.bool(forKey: "vegetariano")
        notificationSwitch.isOn = UserDefaults.standard.bool(forKey: notificationsUserDefaultsString)
        // back button color
        self.navigationController?.navigationBar.tintColor = UIColor(red:0.96, green:0.42, blue:0.38, alpha:1.0)
        
        // disable highlight on veggie's cell. its only possible to click on switch
        self.veggieTableViewCell.selectionStyle = .none;
        
        

        tableView.reloadData()
        
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
        
        if indexPath.section == 2 && indexPath.row == 0 {
            UIApplication.shared.openURL(URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSekvO0HnnfGnk0-FLTX86mVxAOB5Uajq8MPmB0Sv1pXPuQiCg/viewform")!)
        }
    }
    
   
    
    // - MARK: notifications
    
    
    @IBAction func notificationSwitchToggled(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: notificationsUserDefaultsString)
        
        if(sender.isOn) {
            
            requestNotificationPermission()
            
            
            if #available(iOS 10.0, *) {
                requestNotification()
            } else {
                // Fallback on earlier versions
            }

            // TODO: REMOVE THIS
            
        } else { // Desabilitar notificacao
            
            if #available(iOS 10.0, *) {
                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                print("Notificações removidas")
            } else {
                // Fallback on earlier versions
            }
        }
        
        tableView.reloadData()
    }
    
    
    
    
    
    func requestNotificationPermission() {
        
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            let options: UNAuthorizationOptions = [.alert, .sound]
            
            center.requestAuthorization(options: options) {
                (granted, error) in
                if !granted {
                    print("Permissao para notificacoes negada!")
                }
            }
        } else {
            // TODO: iOS 9
        }
        
    }
    
  
    
    /*
     TODO
     
     - Pegar o primeiro cardapio e ver se ele é o dia dia.
     - Escolher entre tradicional e vegetariano.
     - So mandar notificacao se tiver cardapio correto.
     
     
     */
    
    @available(iOS 10.0, *)
    func requestNotification() {
     
        UIApplication.shared.registerForRemoteNotifications()
        
    }
    
   
  
}

