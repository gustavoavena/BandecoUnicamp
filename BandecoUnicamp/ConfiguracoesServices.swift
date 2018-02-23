//
//  ConfiguracoesServices.swift
//  BandecoUnicamp
//
//  Created by Gustavo Avena on 23/2/18.
//  Copyright © 2018 Gustavo Avena. All rights reserved.
//

import UIKit
import UserNotifications

class ConfiguracoesServices: NSObject {

    public static let shared: ConfiguracoesServices = ConfiguracoesServices()
    
    
    private override init() {}
    
    // MARK: - Dieta
    
    func setDietaValue(_ vegetariano: Bool) {
        UserDefaults(suiteName: "group.bandex.shared")!.set(vegetariano, forKey: VEGETARIANO_KEY_STRING)
        
        registerDeviceToken()
    }
    
    // MARK: - Device tokens
    func registerDeviceToken() {
        UnicampServer.registerDeviceToken()
    }
    
    func unregisterDeviceToken(token: String) {
        UnicampServer.unregisterDeviceToken(token: token)
    }
    
    // MARK: - Notificacoes
    
    @available(iOS 10.0, *)
    func enableNotifications(_ completionHandler: @escaping () -> Void) {
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            
            guard settings.authorizationStatus == .authorized else {
                print("Notificacoes nao autorizadas pelo usuario.")
                return
            }
            
            UserDefaults.standard.set(true, forKey: NOTIFICATION_KEY_STRING)
            
            // Executing is main queue because of warning from XCode 9 thread sanitizer.
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
                
                if UserDefaults.standard.string(forKey: ALMOCO_TIME_KEY_STRING) == nil {
                    print("Configurando horario para notificacao do almoco pela primeira vez")
                    UserDefaults.standard.set("11:00", forKey: ALMOCO_TIME_KEY_STRING)
                }
                
                if UserDefaults.standard.string(forKey: JANTAR_TIME_KEY_STRING) == nil{
                    print("Configurando horario para notificacao do jantar pela primeira vez")
                    UserDefaults.standard.set("17:00", forKey: JANTAR_TIME_KEY_STRING)
                }
                
                completionHandler()
            }
        }
    }
    
    func disableNotifications(_ completionHandler: @escaping () -> Void) {
        if let token = UserDefaults.standard.object(forKey: "deviceToken") as? String {
            unregisterDeviceToken(token: token)
            
            UserDefaults.standard.set(nil, forKey: ALMOCO_TIME_KEY_STRING)
            UserDefaults.standard.set(nil, forKey: JANTAR_TIME_KEY_STRING)
        } else {
            print("Device token nao encontrado para ser removido")
        }
        
        UserDefaults.standard.set(false, forKey: NOTIFICATION_KEY_STRING)
        
        DispatchQueue.main.async {
            completionHandler()
        }
    }
    
    
}
