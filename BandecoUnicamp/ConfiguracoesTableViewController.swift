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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return notificationSwitch.isOn ? 3 : 1
        case 2:
            return 2
        default:
            return 0
        }
        
    }
    
    // - MARK: notifications
    
    
    @IBAction func notificationSwitchToggled(_ sender: UISwitch) {
        if(sender.isOn) {
            
            // TODO: REMOVE THIS
            if #available(iOS 10.0, *) {
                requestNotificationPermission()
            } else {
                // Fallback on earlier versions
                requestNotificationPermissionForIOS9()
            }
            
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
    
    
    
    
    
    @available(iOS 10.0, *)
    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound]
        
        center.requestAuthorization(options: options) {
            (granted, error) in
            if !granted {
                print("Permissao para notificacoes negada!")
            }
        }
        
    }
    
    func requestNotificationPermissionForIOS9() {
        // TODO
    }
    
    /*
     TODO
     
     - Pegar o primeiro cardapio e ver se ele é o dia dia.
     - Escolher entre tradicional e vegetariano.
     - So mandar notificacao se tiver cardapio correto.
     
     
     */
    
    @available(iOS 10.0, *)
    func requestNotification() {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        let cardapio: Cardapio? = Cache.shared().cardapios.count > 0 ? Cache.shared().cardapios[0] : nil
        
        
        if let cardapio = cardapio {
            content.title = "Cardapio do \("almoço:")"
            content.body = cardapio.almoco.pratoPrincipal
        } else {
            content.title = "Don't forget"
            content.body = "Buy some milk"
        }
        content.sound = UNNotificationSound.default()
        
        let date = Date()
        let componentes = DateComponents(calendar: Calendar.current, hour: 12, minute: 36, second: 0)
//        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.second,], from: date)
        
        
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
        let trigger = UNCalendarNotificationTrigger(dateMatching: componentes, repeats: true)
        
        let identifier = "UYLLocalNotification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                // Something went wrong
                print("Erro ao registrar a notificacao")
            } else {
                print("\n\n\n\nNotificacao registrada com sucesso\n\n\n\n")
            }
        })
        
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
