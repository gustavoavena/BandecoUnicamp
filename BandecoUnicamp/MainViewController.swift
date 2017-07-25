//
//  MainViewController.swift
//  BandecoUnicamp
//
//  Created by Gustavo Avena on 24/07/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    let errorString = "Desculpa, estamos com problemas técnicos!"

    @IBOutlet weak var typeSegmentedControl: UISegmentedControl!
    weak var pageViewController: PageViewController!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()


        // carrega a view com o segmentedControl correto para sua dieta. Pela primeira vez, isso comeca como false.
        typeSegmentedControl.selectedSegmentIndex = UserDefaults(suiteName: "group.bandex.shared")!.bool(forKey: "vegetariano") ? 1 : 0
        
      
        
        
//        self.pageViewController.cardapios = CardapioServices.getAllCardapios() {
//            (cardapios) in
//            
//            // TODO: error label
//            
//            
////            self.pageViewController.reloadData()
//        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "embedPage" {
            
            let controller = segue.destination as! PageViewController
            
            self.pageViewController = controller
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
