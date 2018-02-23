//
//  MainViewController.swift
//  BandecoUnicamp
//
//  Created by Gustavo Avena on 24/07/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//


import UIKit
import StoreKit

class MainViewController: GAITrackedViewController {
    
    let errorString = "Desculpe, não foi possível carregar o cardápio."

    weak var pageViewController: PageViewController!
    var lastRefreshed: Date = Date()
    
    func displayAlert() {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        // Change font of the title and message
        let titleFont:[String : AnyObject] = [ NSFontAttributeName : UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium) ]
        let messageFont:[String : AnyObject] = [ NSFontAttributeName : UIFont.systemFont(ofSize: 14) ]
        
        let attributedTitle = NSMutableAttributedString(string: "Bem vindo ao Bandex!", attributes: titleFont)
        let attributedMessage = NSMutableAttributedString(string: "Qual a sua preferência de cardápio?", attributes: messageFont)
        
        alert.setValue(attributedTitle, forKey: "attributedTitle")
        alert.setValue(attributedMessage, forKey: "attributedMessage")
        
        // Tradicional
        let action1 = UIAlertAction(title: "Tradicional", style: .default, handler: { (action) -> Void in
            
            UserDefaults(suiteName: "group.bandex.shared")!.set(false, forKey: "vegetariano")
            self.dietaMayHaveChanged()
        })
        
        // Vegetariano
        let action2 = UIAlertAction(title: "Vegetariano", style: .default, handler: { (action) -> Void in
            UserDefaults(suiteName: "group.bandex.shared")!.set(true, forKey: "vegetariano")
//            self.typeSegmentedControl.selectedSegmentIndex = 1
            self.dietaMayHaveChanged()
        })
        
        alert.addAction(action1)
        alert.addAction(action2)
        
        self.present(alert, animated: true, completion: nil)
        
    }

    @available(iOS 10.3, *)
    fileprivate func askForReview() {
        
        let launchCount = UserDefaults.standard.integer(forKey: "launchCount")
        let didAskForReview = UserDefaults.standard.bool(forKey: "didAskForReview")
        
        if launchCount >= 5 && !didAskForReview {
            print("Asking for review...")
            
            // Ask for review
            SKStoreReviewController.requestReview()
           
            
            UserDefaults.standard.set(true, forKey: "didAskForReview")
        } else {
            print("Not asking for review")
        }
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Loading MainViewController...")
    
    
        let firstLaunchKeyString = "FirstLaunchHappened"
        if !UserDefaults.standard.bool(forKey: firstLaunchKeyString) {
            // TODO: Alerta com pergunta de dieta AQUI
            displayAlert()
            UserDefaults.standard.set(true, forKey: firstLaunchKeyString)
        }
    
        
        if #available(iOS 10.3, *) {
            askForReview()
        }
       
        pageViewController.vegetariano = UserDefaults(suiteName: "group.bandex.shared")!.bool(forKey: "vegetariano")
    }
    

    
    
    
    /// Checa se passaram 30min desde a ultima atualizacao para evitar requests desnecessarios que deixam o app lento.
    func checkIfNeedsRefreshing() {
        let INTERVALO_DE_RELOAD = 5 // em minutos
        
        let components = Calendar.current.dateComponents([.minute], from: lastRefreshed, to: Date())
        
        
        if let minutes = components.minute, minutes > INTERVALO_DE_RELOAD || pageViewController.cardapios.count == 0 {
            print("Atualizando cardapios. Minutos desde ultima atualizacao: \(minutes).")
            // Faz request e atualiza cardapios.
            self.pageViewController.reloadCardapios() {
                success in
                
                if success {
                    self.lastRefreshed = Date()
                }
            }
            
        } 
    }
    
    func dietaMayHaveChanged() {
        
        // TODO: armazenar opcao de vegetariano comente no ConfiguracoesServices.
        
        // Coloquei esse if para ele nao ficar setando o atributo pageViewController.vegetariano sem necessidade, ja que esse atributo chama um metodo para reinstanciar todos os view controllers.
        if(UserDefaults(suiteName: "group.bandex.shared")!.bool(forKey: "vegetariano") != pageViewController.vegetariano) {
            pageViewController.vegetariano = UserDefaults(suiteName: "group.bandex.shared")!.bool(forKey: "vegetariano")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        dietaMayHaveChanged()
        
        checkIfNeedsRefreshing()
        
        self.screenName = "mainViewController"
        let name = "mainViewController"
        
        // The UA-XXXXX-Y tracker ID is loaded automatically from the
        // GoogleService-Info.plist by the `GGLContext` in the AppDelegate.
        // If you're copying this to an app just using Analytics, you'll
        // need to configure your tracking ID here.
        // [START screen_view_hit_swift]
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: name)
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
        // [END screen_view_hit_swift]

        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "embedPage" {
            
            let controller = segue.destination as! PageViewController
            
            self.pageViewController = controller
        }
    }

}
