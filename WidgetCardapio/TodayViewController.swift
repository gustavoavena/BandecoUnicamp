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
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    }
    
    
    // mostra poucas infos caso esteja no modo compacto, e todas info no modo expandido
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        
        let expanded = activeDisplayMode == .expanded
        preferredContentSize = expanded ? CGSize(width: maxSize.width, height: 226) : maxSize
        
        guard widgetTableViewController != nil else {
            print("widgetTableViewController is nil")
            return
        }
        
        widgetTableViewController.widgetSizeChanged(expanded: expanded)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //abre o aplicativo ao clicar no widget
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        extensionContext?.open(URL(string: "Bandex://")!, completionHandler: { (success) in
            if (!success) {
                print("error")
            }
        })
    }

    private func getTipoRefeicaoParaExibir(dataCardapio: Date) -> TipoRefeicao {
        let horaAtual = Calendar.current.component(.hour, from: Date())
        let diaDaSemanaAtual = Calendar.current.component(.weekday, from: Date())
        
        let (almoco, jantar): (TipoRefeicao,TipoRefeicao) = UserDefaults(suiteName: "group.bandex.shared")!.bool(forKey: "vegetariano") ? (.almocoVegetariano, .jantarVegetariano) : (.almoco, .jantar)
        
        if (2...6).contains(diaDaSemanaAtual) {
            if (14...20).contains(horaAtual) {
                return jantar
            } else {
                return almoco
            }
        } else {
            return almoco
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateWidget() {
            (success) in
            if success {
                print("widget updated")
            } else {
                print("error updating widget before appearing")
            }
        }
    }
    
   
    func cardapioProxDia() -> Bool {
        let hora = Calendar.current.component(.hour, from: Date())
        
        return hora > 19 ? true : false
    }
    

    
    // FIXME: widget nao atualiza logo no Today Menu apos alterar dieta... Ele atualiza na hora no Force Touch do icone.
    fileprivate func updateWidget(completionHandler: (@escaping (Bool) -> Void)) {
       
        let cardapios = CardapioServices.getAllCardapios()
        
        let numeroCardapio = cardapioProxDia() ? 1 : 0
        
        guard cardapios.count > numeroCardapio else {
            print("nao veio nenhum cardapio.")
            widgetTableViewController.displayError()
            completionHandler(false)
            return
        }
        
        guard widgetTableViewController != nil else {
            print("widgetTableViewController is nil")
            return
        }
        
        
        let cardapioDia = cardapios[numeroCardapio]

        print(cardapioDia)
        
        let tipo = self.getTipoRefeicaoParaExibir(dataCardapio: cardapioDia.data)
        
        widgetTableViewController.setCardapioValues(refeicao: tipo.rawValue, pratoPrincipal: cardapioDia[tipo].pratoPrincipal, sobremesa: cardapioDia[tipo].sobremesa, suco: cardapioDia[tipo].suco, guarnicao: cardapioDia[tipo].guarnicao, salada: cardapioDia[tipo].salada, pts: cardapioDia[tipo].pts, data: cardapioDia.data)
       
        
        completionHandler(true)
            
    }
        
    

    
    // TODO: metodo que define qual refeicao sera mostrada no momento (almoco/jantar ou almoco/jantar vegetariano), dependendo da hora e da dieta do usuario.
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
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
