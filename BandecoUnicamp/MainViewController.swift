//
//  MainViewController.swift
//  BandecoUnicamp
//
//  Created by Gustavo Avena on 24/07/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit

class MainViewController: GAITrackedViewController {
    
    let errorString = "Desculpa, estamos com problemas técnicos!"

    @IBOutlet weak var typeSegmentedControl: UISegmentedControl!
    weak var pageViewController: PageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // carrega a view com o segmentedControl correto para sua dieta. Pela primeira vez, isso comeca como false.
        typeSegmentedControl.selectedSegmentIndex = UserDefaults(suiteName: "group.bandex.shared")!.bool(forKey: "vegetariano") ? 1 : 0
        
        self.screenName = "mainViewController"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
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
    @IBAction func segmentedValueChanged(_ sender: Any) {
        self.pageViewController.vegetariano = (typeSegmentedControl.selectedSegmentIndex == 1)
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
