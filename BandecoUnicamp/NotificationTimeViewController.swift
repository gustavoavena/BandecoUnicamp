//
//  NotificationTimeViewController.swift
//  BandecoUnicamp
//
//  Created by Julianny Favinha on 1/11/18.
//  Copyright © 2018 Gustavo Avena. All rights reserved.
//

import UIKit

class NotificationTimeViewController: UIViewController {
    
    var refeicao: TipoRefeicao!
    
    var selectedTime: String!
    
    let almocoNotificationTimeString = "notificacao_almoco"
    let jantarNotificationTimeString = "notificacao_jantar"
    
    /*
     Almoco: 07:00-13:59
     Jantar: 14:00-19:00
    */
    
    var pickerTimeAlmoco = [
        ["Nenhum", "7:00", "7:30",
         "8:00", "8:30",
         "9:00", "9:30",
         "10:00", "10:30",
         "11:00", "11:30",
         "12:00", "12:30",
         "13:00", "13:30",
         "14:00"]
    ]
    
    var pickerTimeJantar = [
        ["Nenhum", "14:00", "14:30",
         "15:00", "15:30",
         "16:00", "16:30",
         "17:00", "17:30",
         "18:00", "18:30",
         "19:00"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (self.refeicao == .almoco) {
            self.navigationItem.title = "Horário almoço"
        }
        else {
            self.navigationItem.title = "Horário jantar"
        }
        
        self.pickerView.sele
        
        print("Recebi cardapio \(self.refeicao.rawValue)")
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("Usuário definiu horário \(selectedTime)")
        
        UserDefaults.standard.set(self.selectedTime == "Nenhum" ? nil : self.selectedTime, forKey: self.refeicao == .almoco ? almocoNotificationTimeString : jantarNotificationTimeString)

    }

}

extension NotificationTimeViewController: UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if (self.refeicao == .almoco) {
            return self.pickerTimeAlmoco.count
        }
        
        return self.pickerTimeJantar.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        var componentData: [String]
        
        // recupera os valores da coluna "component"
        if (self.refeicao == .almoco) {
            componentData = self.pickerTimeAlmoco[component]
        }
        else {
            componentData = self.pickerTimeJantar[component]
        }

        return componentData.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if (self.refeicao == .almoco) {
            return self.pickerTimeAlmoco[component][row]
        }
        
        return self.pickerTimeJantar[component][row]
        
    }
}

extension NotificationTimeViewController: UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if (self.refeicao == .almoco) {
            self.selectedTime = self.pickerTimeAlmoco[component][row]
        }
        else {
            self.selectedTime = self.pickerTimeJantar[component][row]
        }
        print("Usuário selecionou horário \(selectedTime)")
        
    }
}
