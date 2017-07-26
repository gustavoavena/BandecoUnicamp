//
//  MainViewController.swift
//  BandecoUnicamp
//
//  Created by Gustavo Avena on 24/07/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    let errorString = "Desculpe, não foi possível carregar o cardápio."

    @IBOutlet weak var typeSegmentedControl: UISegmentedControl!
    weak var pageViewController: PageViewController!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()


        // carrega a view com o segmentedControl correto para sua dieta. Pela primeira vez, isso comeca como false.
        typeSegmentedControl.selectedSegmentIndex = UserDefaults(suiteName: "group.bandex.shared")!.bool(forKey: "vegetariano") ? 1 : 0
        
      

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
