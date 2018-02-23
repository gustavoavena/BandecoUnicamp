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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dietaSwitch.isOn = UserDefaults(suiteName: "group.bandex.shared")!.bool(forKey: VEGETARIANO_KEY_STRING)
        
        // back button color
        self.navigationController?.navigationBar.tintColor = UIColor(red:0.96, green:0.42, blue:0.38, alpha:1.0)
        
        // disable highlight on veggie's cell. its only possible to click on switch
        self.veggieTableViewCell.selectionStyle = .none;

        tableView.reloadData()
        loadNotificationOptions()
        
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
        ConfiguracoesServices.shared.setDietaValue(sender.isOn)
    }
    
    
    // - MARK: Notificacoes
    
    /// Responsavel por atualizar todo o UI relacionado as notificacoes. Toda vez que alguma opcao de notificacao for alterada, esse metodo deve ser chamado para
    // garantir que os textos dos horarios estejamo corretos e as linhas das notificacoes das refeicoes aparecam somente se ativadas.
    func loadNotificationOptions() {
        notificationSwitch.isOn = UserDefaults.standard.bool(forKey: NOTIFICATION_KEY_STRING)
        
        // TODO: setar o numero de linhas e as opcoes de notificacoes (ativadas ou nao, horario, etc) baseadp no User Defaults.
        // e.g. notificacao_almoco = "12:00" e notificacao_jantar = nil
        
        
        if let hora_almoco = UserDefaults.standard.string(forKey: ALMOCO_TIME_KEY_STRING) {
            print("Setando horario da notificacao do almoco: \(hora_almoco)")
            almocoNotificationCell.detailTextLabel?.text = hora_almoco
        } else {
            print("Horario pra notificacao do almoco nao encontrado.")
            // nao colocar linhas a mais na table view...
        }
        
        if let hora_jantar = UserDefaults.standard.string(forKey: JANTAR_TIME_KEY_STRING) {
            print("Setando horario da notificacao do jantar: \(hora_jantar)")
            jantarNotificationCell.detailTextLabel?.text = hora_jantar
        } else {
            // nao colocar linhas a mais na table view...
            print("Horario pra notificacao do jantar nao encontrado.")
        }
    }
    
    
    @IBAction func notificationSwitchToggled(_ sender: UISwitch) {

        if #available(iOS 10.0, *) {
            if(sender.isOn) {
                registerForPushNotifications()
            } else { // Desabilitar notificacao
                ConfiguracoesServices.shared.disableNotifications() {
                    self.loadNotificationOptions()
                }
            }
        }
        
        tableView.reloadData()
    }
    
    
    @available(iOS 10.0, *)
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) {
            (granted, error) in
            
            guard granted else { return }
            ConfiguracoesServices.shared.enableNotifications() {
                self.loadNotificationOptions()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destiny = segue.destination as? NotificationTimeViewController {
            destiny.notificationTimeDisplayDelegate = self
            
            if segue.identifier == "SegueAlmocoTime" {
                destiny.refeicao = TipoRefeicao.almoco
                destiny.pickerTimeOptions = destiny.ALMOCO_TIME_OPTIONS
                //destiny.selectedTime =
            }
            
            if segue.identifier == "SegueJantarTime" {
                destiny.refeicao = TipoRefeicao.jantar
                destiny.pickerTimeOptions = destiny.JANTAR_TIME_OPTIONS
            }
        }
    }
    
    
    // MARK: - Table view methods
    
    // Abre o feedback form no Safari
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 2 && indexPath.row == 0 {
            UIApplication.shared.openURL(URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSekvO0HnnfGnk0-FLTX86mVxAOB5Uajq8MPmB0Sv1pXPuQiCg/viewform")!)
            tableView.deselectRow(at: indexPath, animated: true)
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

extension ConfiguracoesTableViewController: NotificationTimeDisplayDelegate {
    
    func updateTimeString(time: String, refeicao: TipoRefeicao) {
        let cell = refeicao == .almoco ? almocoNotificationCell : jantarNotificationCell
        cell?.detailTextLabel?.text = time
    }
    
    
}

