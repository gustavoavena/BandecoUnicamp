//
//  PageViewController.swift
//  BandecoUnicamp
//
//  Created by Gustavo Avena on 24/07/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit

protocol DateDisplay {
    func refreshDate(newDate: Date)
}

class PageViewController: UIPageViewController, UIPageViewControllerDataSource {

    var cardapios: [Cardapio] = UnicampServer.getAllCardapios()
    var dateDisplay: DateDisplay?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        
        reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadData() {
        
        
        if let _ = cardapios.first {
            let vc = cardapioItemViewController(forCardapio: 0)
            self.setViewControllers([vc], direction: .forward, animated: false, completion: nil)
            updateDate()
        } else {
            print("Sem cardapios no page view controller")
        }
        
    }
    
    func updateDate() {
        if let vc = self.viewControllers?.first as? CardapioTableViewController,
            let cardapio = vc.cardapio {
            dateDisplay?.refreshDate(newDate: cardapio.data)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let index = indexOfDataItem(forViewController: viewController)
 
        
        let previousIndex = index - 1
        
        guard previousIndex >= 0 else {return nil}
        
        guard cardapios.count > previousIndex else {return nil}
        
        updateDate()
        
        return cardapioItemViewController(forCardapio: previousIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let vcIndex = indexOfDataItem(forViewController: viewController)
        
        let nextIndex = vcIndex + 1
        
        guard cardapios.count != nextIndex else { return nil}
        
        guard  cardapios.count > nextIndex else { return nil }
        
        updateDate()
        return cardapioItemViewController(forCardapio: nextIndex)
    }
    
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let currentViewController = pageViewController.viewControllers?.first else { fatalError("Unable to get the page controller's current view controller.") }
        
        return indexOfDataItem(forViewController: currentViewController)
    }
    
    func indexOfCardapio(cardapio: Cardapio) -> Int? {
        for i in 0..<cardapios.count {
            if cardapios[i].data == cardapio.data {
                return i
            }
        }
        
        return nil
    }
    
    // TODO: pega index do cardapio, dado um view controller.
    private func indexOfDataItem(forViewController viewController: UIViewController) -> Int {
        guard let viewController = viewController as? CardapioTableViewController else {
            fatalError("Unexpected view controller type in page view controller.")
        }
        
        guard let cardapio = viewController.cardapio,
            let viewControllerIndex = indexOfCardapio(cardapio: cardapio) else {
                fatalError("View controller's data item not found.")
        }
        
        return viewControllerIndex
    }

    
    private func cardapioItemViewController(forCardapio pageIndex: Int) -> CardapioTableViewController {
        
//        var cardapio: Cardapio! = nil
        
        // Instantiate and configure a `DataItemViewController` for the `DataItem`.
        guard let controller = storyboard?.instantiateViewController(withIdentifier: CardapioTableViewController.storyboardIdentifier) as? CardapioTableViewController else {
            fatalError("Unable to instantiate a CardapioTableViewController.")
        }
        
        guard pageIndex >= 0, pageIndex < self.cardapios.count else {
            fatalError("Index out of range in cardapios.")
        }
        
        let cardapio = self.cardapios[pageIndex]
        let vegetariano = UserDefaults(suiteName: "group.bandex.shared")!.bool(forKey: "vegetariano")
        controller.cardapio = cardapio
        controller.vegetariano = vegetariano

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
