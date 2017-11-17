//
//  TodayViewController.swift
//  WidgetCardapio
//
//  Created by Gustavo Avena on 215//17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit
import NotificationCenter


class TodayViewController: UIViewController, NCWidgetProviding {
    
    weak var widgetTableViewController: WidgetTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        if #available(iOSApplicationExtension 10.0, *) {
            extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        } else {
            preferredContentSize = CGSize(width: self.view.frame.width, height: 184)
            widgetTableViewController.guarnicao.textColor = UIColor.lightGray
            widgetTableViewController.pratoPrincipal.textColor = UIColor.lightGray
            widgetTableViewController.suco.textColor = UIColor.lightGray
            widgetTableViewController.sobremesa.textColor = UIColor.lightGray
            widgetTableViewController.salada.textColor = UIColor.lightGray
            widgetTableViewController.pts.textColor = UIColor.lightGray
            // Fallback on earlier versions
        }
    }
    
    
    // mostra poucas infos caso esteja no modo compacto, e todas info no modo expandido
    @available(iOSApplicationExtension 10.0, *)
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        
        let expanded = activeDisplayMode == .expanded
        preferredContentSize = expanded ? CGSize(width: maxSize.width, height: 184) : maxSize
        
        guard widgetTableViewController != nil else {
            print("widgetTableViewController is nil")
            return
        }
        
    }
    
    //abre o aplicativo ao clicar no widget
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        extensionContext?.open(URL(string: "Bandex://")!, completionHandler: { (success) in
            if (!success) {
                print("error")
            }
        })
    }

    
   
    
    

    
    // FIXME: widget nao atualiza logo no Today Menu apos alterar dieta... Ele atualiza na hora no Force Touch do icone.
    fileprivate func updateWidget(completionHandler: (@escaping (Bool) -> Void)) {

        let (proxRefeicao, proxData) = CardapioServices.shared.getWidgetRefeicaoData()
        
        guard let refeicao = proxRefeicao, let data = proxData else {
            widgetTableViewController.displayError()
            completionHandler(false)
            return
        }
        
        guard widgetTableViewController != nil else {
            print("widgetTableViewController is nil")
            completionHandler(false)
            return
        }

        widgetTableViewController.setCardapioValues(refeicao: refeicao, data: data)
       
        
        completionHandler(true)
    }
        
    

    
    // TODO: metodo que define qual refeicao sera mostrada no momento (almoco/jantar ou almoco/jantar vegetariano), dependendo da hora e da dieta do usuario.
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        print("performing automatic update!")
        updateWidget() {
            (success) in

            if success {
                completionHandler(.newData)
            } else {
                completionHandler(.failed)
            }
        }

    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "EmbedSegue" {
            
            let controller = segue.destination as! WidgetTableViewController
            
            self.widgetTableViewController = controller
        }
    }

    
}
