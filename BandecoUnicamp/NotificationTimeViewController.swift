//
//  NotificationTimeViewController.swift
//  BandecoUnicamp
//
//  Created by Julianny Favinha on 1/11/18.
//  Copyright © 2018 Gustavo Avena. All rights reserved.
//

import UIKit

protocol NotificationTimeDisplayDelegate {
    func updateTimeString(time: String, refeicao: TipoRefeicao)
}
class NotificationTimeViewController: UIViewController {
    
    var refeicao: TipoRefeicao!
    var selectedTime: String!
    
//    let almocoNotificationTimeString = "notificacao_almoco"
//    let jantarNotificationTimeString = "notificacao_jantar"
    
    var notificationTimeDisplayDelegate: NotificationTimeDisplayDelegate?
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    /*
     Almoco: 07:00-13:59
     Jantar: 14:00-19:00
    */
    
    let ALMOCO_TIME_OPTIONS = [
        "Nenhum", "7:00", "7:30",
         "8:00", "8:30",
         "9:00", "9:30",
         "10:00", "10:30",
         "11:00", "11:30",
         "12:00", "12:30",
         "13:00", "13:30",
         "14:00"
    ]
    
    let JANTAR_TIME_OPTIONS = [
        "Nenhum", "14:00", "14:30",
         "15:00", "15:30",
         "16:00", "16:30",
         "17:00", "17:30",
         "18:00", "18:30",
         "19:00"
    ]
    
    var pickerTimeOptions: [String]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let currentNotificationTime: String? = UserDefaults.standard.object(forKey: refeicao == .almoco ? almocoNotificationTimeString : jantarNotificationTimeString) as? String
        
        
        if let currentTime = currentNotificationTime, let row = pickerTimeOptions!.index(of: currentTime) {
            self.pickerView.selectRow(row, inComponent: 0, animated: true)
        }
        
        print("Recebi cardapio \(self.refeicao.rawValue)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("Usuário definiu horário \(selectedTime)")
        
        // so salva quando o usuario realmente terminar de escolher e o VC for desaparecer.
        
        UserDefaults.standard.set(self.selectedTime == "Nenhum" ? nil : self.selectedTime, forKey: self.refeicao == .almoco ? almocoNotificationTimeString : jantarNotificationTimeString)
    }

}

extension NotificationTimeViewController: UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        return pickerTimeOptions.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return self.pickerTimeOptions[row]
    }
}

extension NotificationTimeViewController: UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.selectedTime = self.pickerTimeOptions[row]
        
        if let delegate = self.notificationTimeDisplayDelegate {
            OperationQueue.main.addOperation {
                delegate.updateTimeString(time: self.pickerTimeOptions[row], refeicao: self.refeicao)
            }
        }
        print("Usuário selecionou horário \(selectedTime)")
    }
}
