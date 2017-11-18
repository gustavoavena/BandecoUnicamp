//
//  PageViewController.swift
//  BandecoUnicamp
//
//  Created by Gustavo Avena on 24/07/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit



class PageViewController: UIPageViewController, UIPageViewControllerDataSource {

    var errorUpdating: Bool = false
    var cardapios: [Cardapio] = CardapioServices.shared.getAllCardapios()
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
        
        // Colocar mensagem de erro na label de data de todos os view controllers (caso haja cardapios). Caso nao haja cardapios, instanciar ErroViewController.
        
        setViewControllers([controller], direction: .forward, animated: false, completion: nil)
    }
    

    func alertarErroNovo() {
        
        if let vcs = self.viewControllers as? [CardapioTableViewController], vcs.count > 0 {
            for vc in vcs {
                vc.errorUpdating = true
            }
        } else {
            alertarErro()
        }
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
    
    fileprivate func setupAppearance(_ show: Bool) {
        let appearance = UIPageControl.appearance()
        appearance.isHidden = !show
    }
    
    func loadData() {
        
        if let _ = cardapios.first {
            let vc = cardapioItemViewController(forCardapio: 0)
            self.setViewControllers([vc], direction: .forward, animated: false, completion: nil)
            setupAppearance(true)
        } else {
            print("Sem cardapios no page view controller")
            alertarErro()
            setupAppearance(false)
        }
    }
    
    func reloadCardapios(completionHandler: (Bool)->Void) {
        let newCardapios = CardapioServices.shared.getAllCardapios()
        
        if newCardapios.count > 0 {
            self.cardapios = newCardapios
            self.errorUpdating = false
            loadData()
            completionHandler(true)
        } else {
            self.errorUpdating = true
            alertarErroNovo()
            print("Cardapios nao atualizados devido a erro.")
            completionHandler(false)
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
    
    private func indexOfDataItem(forViewController viewController: UIViewController) -> Int {
        guard let viewController = viewController as? CardapioTableViewController else {
            print("Unexpected view controller type in page view controller.")
            return 0
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
        controller.errorUpdating = self.errorUpdating

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
