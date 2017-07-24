//
//  PageViewController.swift
//  BandecoUnicamp
//
//  Created by Gustavo Avena on 24/07/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource {

    let cardapio: Cardapio!
    
    var currentCardapio: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = indexOfDataItem(forViewController: viewController)
        
        if index > 0 {
            return dataItemViewController(forPage: index - 1)
        }
        else {
            return nil
        }
    }
    
    private func indexOfDataItem(forViewController viewController: UIViewController) -> Int {
        guard let viewController = viewController as? CardapioTableViewController else {
            fatalError("Unexpected view controller type in page view controller.")
        }
        
        guard let viewControllerIndex = Cache.shared().cardapios.index(of: viewController.page) else { fatalError("View controller's data item not found.")
        }
        
        return viewControllerIndex
    }

    
    private func dataItemViewController(forCardapio pageIndex: Int) -> CardapioTableViewController {
        
        var cardapio: Cardapio! = nil
        
        // Instantiate and configure a `DataItemViewController` for the `DataItem`.
        guard let controller = storyboard?.instantiateViewController(withIdentifier: CardapioTableViewController.storyboardIdentifier) as? CardapioTableViewController else {
            fatalError("Unable to instantiate a CardapioTableViewController.")
        }
        
        if currentCardapio < Cache.shared().cardapios.count
        {
            cardapio = Cache.shared().cardapios[currentCardapio]
        }
        
        if cardapio != nil {
            
           
            let vegetariano = UserDefaults(suiteName: "group.bandex.shared")!.bool(forKey: "vegetariano")
            
            
            controller.setCardapio(almoco: vegetariano ? cardapio.almocoVegetariano : cardapio.almoco, jantar: vegetariano ? cardapio.jantarVegetariano : cardapio.jantar)
            
            
        }
        
        return controller
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
