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
    
  
    @IBOutlet weak var almocoNotificationCell: UITableViewCell!
    @IBOutlet weak var jantarNotificationCell: UITableViewCell!
    
    
    let notificationsUserDefaultsString = "notificationsEnabled"

    
    /// Responsavel por atualizar todo o UI relacionado as notificacoes. Toda vez que alguma opcao de notificacao for alterada, esse metodo deve ser chamado para
    // garantir que os textos dos horarios estejamo corretos e as linhas das notificacoes das refeicoes aparecam somente se ativadas.
    func loadNotificationOptions() {
        notificationSwitch.isOn = UserDefaults.standard.bool(forKey: notificationsUserDefaultsString)
        
        // TODO: setar o numero de linhas e as opcoes de notificacoes (ativadas ou nao, horario, etc) baseadp no User Defaults.
        // e.g. notificacao_almoco = "12:00" e notificacao_jantar = nil
        
        // almocoSwitch.isOn = UserDefaults(suiteName: "group.bandex.shared").string(forKey: "notificacao_almoco")
        // jantarSwitch.isOn = UserDefaults(suiteName: "group.bandex.shared").string(forKey: "notificacao_jantar")
        
        //        if let hora_almoco = UserDefaults(suiteName: "group.bandex.shared").string(forKey: "notificacao_almoco") as String? {
        //            almocoSwitch.isOn =  true
        //            // Colocar linha do almoco
        //            // almocoTimeString.text = hora_almoco
        //        } else {
        //            almocoSwitch.isOn = false
        //            // nao colocar linhas a mais na table view...
        //        }
        
        //        if let hora_jantar = UserDefaults(suiteName: "group.bandex.shared").string(forKey: "notificacao_jantar") as String? {
        //            jantarSwitch.isOn =  true
        //            // Colocar linha do almoco
        //            // jantarTimeString.text = hora_jantar
        //        } else {
        //            jantarSwitch.isOn = false
        //            // nao colocar linhas a mais na table view...
        //        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dietaSwitch.isOn = UserDefaults(suiteName: "group.bandex.shared")!.bool(forKey: "vegetariano")
        
        loadNotificationOptions()
        
        
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
        
        if let token = UserDefaults.standard.object(forKey: "deviceToken") as? String {
            print("\nDevice Token: \(token)\n\n")
            
            CardapioServices.shared.registerDeviceToken(token: token)
        }
    }
    
    
    // Abre o feedback form no Safari
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 2 && indexPath.row == 0 {
            UIApplication.shared.openURL(URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSekvO0HnnfGnk0-FLTX86mVxAOB5Uajq8MPmB0Sv1pXPuQiCg/viewform")!)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
   
    
    // - MARK: notifications
    
    
    @IBAction func notificationSwitchToggled(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: notificationsUserDefaultsString)
        
        if(sender.isOn) {
            
            if #available(iOS 10.0, *) {
                registerForPushNotifications()
            } else {
                // Fallback on earlier versions
            }
        } else { // Desabilitar notificacao
            
            if #available(iOS 10.0, *) {
                if let token = UserDefaults.standard.object(forKey: "deviceToken") as? String {
                    CardapioServices.shared.unregisterDeviceToken(token: token)
                    
                    UserDefaults(suiteName: "group.bandex.shared")?.set(nil, forKey: "notificacao_almoco")
                    UserDefaults(suiteName: "group.bandex.shared")?.set(nil, forKey: "notificacao_jantar")
                    self.loadNotificationOptions()
                    
                } else {
                    print("Device token nao encontrado para ser removido")
                }
    
            } else {
                // Fallback on earlier versions
            }
        }
        
        tableView.reloadData()
    }
    
    
    @available(iOS 10.0, *)
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    @available(iOS 10.0, *)
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            
            guard settings.authorizationStatus == .authorized else { return }
            
            // Executing is main queue because of warning from XCode 9 thread sanitizer.
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
                
                // TODO: atualizar opcoes de notificacoes no User Defaults.
                UserDefaults(suiteName: "group.bandex.shared")?.set("11:00", forKey: "notificacao_almoco")
                UserDefaults(suiteName: "group.bandex.shared")?.set("17:00", forKey: "notificacao_jantar")

                // atualizar UI.
                self.loadNotificationOptions()
                
            }
        }
    }
    
    // MARK: Time of notifications
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destiny = segue.destination as? NotificationTimeViewController {
            if segue.identifier == "SegueAlmocoTime" {
                destiny.refeicao = TipoRefeicao.almoco
            }
            
            if segue.identifier == "SegueJantarTime" {
                destiny.refeicao = TipoRefeicao.jantar
            }
        }
    }
    
   
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
            if #available(iOS 10, *)
            {
                
            } else {
                // ios 9 only
                if(section == 1){
                    return 0.01
                }
                
            }
        
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        if #available(iOS 9, *)
        {
            if #available(iOS 10, *)
            {
                
            } else {
                // ios 9 only
                if(section == 1){
                    return 0.01
                }
                
            }
        }
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {


        var rows = [1,notificationSwitch.isOn ? 3 : 1,2]
        
        if #available(iOS 9, *)
        {
            if #available(iOS 10, *)
            {
                
            } else {
                // ios 9 only
                if(section == 1){
                    rows[section] = 0
                }
            }
        }
        
        return rows[section]
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        var title = super.tableView(tableView, titleForFooterInSection: section)
        
        if #available(iOS 9, *)
        {
            if #available(iOS 10, *)
            {
                
            } else {
                // ios 9 only
                if section == 1 {
                    title = ""
                }
                
            }
        }
        
        
        return  title
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = super.tableView(tableView, titleForHeaderInSection: section)
        
        if #available(iOS 9, *)
        {
            if #available(iOS 10, *)
            {
                
            } else {
                // ios 9 only
                if section == 1 {
                    title = ""
                }
                
            }
        }
        return  title
    }
    
    
    
   
  
    
    
    
   
  
}

