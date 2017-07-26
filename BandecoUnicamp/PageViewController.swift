//
//  PageViewController.swift
//  BandecoUnicamp
//
//  Created by Gustavo Avena on 24/07/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit



class PageViewController: UIPageViewController, UIPageViewControllerDataSource {

    var cardapios: [Cardapio] = UnicampServer.getAllCardapios()
    var vegetariano: Bool = UserDefaults(suiteName: "group.bandex.shared")!.bool(forKey: "vegetariano") {
        didSet {
            vegetarianoChanged()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        
        // Setting up the page indicator
        // Uncomment later to enable the page indicator
        let appearance = UIPageControl.appearance()
        appearance.backgroundColor = UIColor.groupTableViewBackground
        appearance.isOpaque = false
        appearance.pageIndicatorTintColor = UIColor.lightGray
        appearance.currentPageIndicatorTintColor = UIColor.gray
        
        
        loadData()
    }
    
    

    func alertarErro() {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "ErroViewController") else {
            fatalError("Unable to instantiate a ErroViewController.")
        }
        
        setViewControllers([controller], direction: .forward, animated: false, completion: nil)
    }
    
    func vegetarianoChanged() {
        if let _ = viewControllers?.first as? CardapioTableViewController {
            let index = presentationIndex(for: self)
            let newVC = cardapioItemViewController(forCardapio: index)
            setViewControllers([newVC], direction: .forward, animated: false, completion: nil)
        } else {
            print("Nenhum view controller exibido")
        }
    }
    
    func loadData() {
        
        if let _ = cardapios.first {
            let vc = cardapioItemViewController(forCardapio: 0)
            self.setViewControllers([vc], direction: .forward, animated: false, completion: nil)
        } else {
            alertarErro()
            print("Sem cardapios no page view controller")
        }
    }
    
  
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let index = indexOfDataItem(forViewController: viewController)
 
        
        let previousIndex = index - 1
        
        guard previousIndex >= 0 else {return nil}
        
        guard cardapios.count > previousIndex else {return nil}
        
        
        return cardapioItemViewController(forCardapio: previousIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let vcIndex = indexOfDataItem(forViewController: viewController)
        
        let nextIndex = vcIndex + 1
        
        guard cardapios.count != nextIndex else { return nil}
        
        guard  cardapios.count > nextIndex else { return nil }
        
        return cardapioItemViewController(forCardapio: nextIndex)
    }
    
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let currentViewController = pageViewController.viewControllers?.first else { fatalError("Unable to get the page controller's current view controller.") }
        
        return indexOfDataItem(forViewController: currentViewController)
    }
    
    // Uncomment to enable the page indicator
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        
        return self.cardapios.count
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
        controller.cardapio = cardapio
        controller.vegetariano = self.vegetariano

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
