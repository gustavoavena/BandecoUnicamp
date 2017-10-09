//
//  MainViewController.swift
//  BandecoUnicamp
//
//  Created by Gustavo Avena on 24/07/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

protocol ScreenshotDelegate {
    
    func screenshot() -> UIImage
}

import UIKit

class MainViewController: GAITrackedViewController {
    
    let errorString = "Desculpe, não foi possível carregar o cardápio."

    @IBOutlet weak var typeSegmentedControl: UISegmentedControl!
    weak var pageViewController: PageViewController!

    var screenshotDelegate: ScreenshotDelegate?
    
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
            self.typeSegmentedControl.selectedSegmentIndex = 0
            self.dietaMayHaveChanged()
        })
        
        // Vegetariano
        let action2 = UIAlertAction(title: "Vegetariano", style: .default, handler: { (action) -> Void in
            UserDefaults(suiteName: "group.bandex.shared")!.set(true, forKey: "vegetariano")
            self.typeSegmentedControl.selectedSegmentIndex = 1
            self.dietaMayHaveChanged()
        })
        
        alert.addAction(action1)
        alert.addAction(action2)
        
        self.present(alert, animated: true, completion: nil)
        
    }

    

    override func viewDidLoad() {
        super.viewDidLoad()

       
        let firstLaunchKeyString = "FirstLaunchHappened"
        
        
        if !UserDefaults.standard.bool(forKey: firstLaunchKeyString) {
            // TODO: Alerta com pergunta de dieta AQUI
            displayAlert()
            UserDefaults.standard.set(true, forKey: firstLaunchKeyString)
        }

        // carrega a view com o segmentedControl correto para sua dieta. Pela primeira vez, isso comeca como false.
        typeSegmentedControl.selectedSegmentIndex = UserDefaults(suiteName: "group.bandex.shared")!.bool(forKey: "vegetariano") ? 1 : 0
    }
    
    func dietaMayHaveChanged() {
        // Coloquei um if para ele so setar vegetariano se o valor for diferente, porque toda vez que ele eh
        // setado, ele da reload no pageviewcontroller. Nao quero fazer isso sem necessidade toda vez que a view
        // for aparecer.
        if pageViewController.vegetariano != (typeSegmentedControl.selectedSegmentIndex == 1) {
            pageViewController.vegetariano = (typeSegmentedControl.selectedSegmentIndex == 1)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        typeSegmentedControl.selectedSegmentIndex = UserDefaults(suiteName: "group.bandex.shared")!.bool(forKey: "vegetariano") ? 1 : 0
        
        dietaMayHaveChanged()
        
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
    
    @IBAction func share(_ sender: UIBarButtonItem) {
        let menu = UIAlertController(title: nil, message: "Escolha o cardápio para compartilhar", preferredStyle: .actionSheet)
        // Descomente a proxima linha para mudar a cor do texto para salmão. Muda também a cor do Cancelar...
        //menu.view.tintColor = UIColor(red:0.96, green:0.42, blue:0.38, alpha:1.0)

        menu.addAction(UIAlertAction(title: "Almoço", style: .default, handler: printCardapioHandler))
        menu.addAction(UIAlertAction(title: "Jantar", style: .default, handler: printCardapioHandler))
        menu.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        self.present(menu, animated: true, completion: nil)
    }
    
    private func printCardapioHandler(selectedOption: UIAlertAction) {
        screenshotDelegate = (pageViewController.viewControllers?.last as! CardapioTableViewController)
        
        (screenshotDelegate as! CardapioTableViewController).screenshotAlmoco = (selectedOption.title == "Almoço")
        
       
        
        let screenshot = (screenshotDelegate?.screenshot())!
        
        let activityVC = UIActivityViewController(activityItems: [screenshot], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func segmentedValueChanged(_ sender: Any) {
        pageViewController.vegetariano = (typeSegmentedControl.selectedSegmentIndex == 1)
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
