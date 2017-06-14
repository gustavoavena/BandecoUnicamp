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
    
    @IBOutlet weak var refeicao: UILabel!
    @IBOutlet weak var pratoPrincipal: UILabel!
    @IBOutlet weak var sobremesa: UILabel!
    @IBOutlet weak var suco: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    // FIXME: widget nao atualiza logo no Today Menu apos alterar dieta... Ele atualiza na hora no Force Touch do icone.
    fileprivate func updateWidget(completionHandler: (@escaping (Bool) -> Void)) {
       
        CardapioServices.getAllCardapios(){
            (cardapios) in
            
            guard cardapios.count > 0 else {
                print("nao veio nenhum cardapio.")
                completionHandler(false)
                return
            }
            let cardapioDia = cardapios[0]
    
            print(cardapioDia)
            
            let tipo = self.getTipoRefeicaoParaExibir(dataCardapio: cardapioDia.data)
            
            self.refeicao.text = tipo.rawValue
            self.pratoPrincipal.text = cardapioDia[tipo].pratoPrincipal
            self.sobremesa.text = cardapioDia[tipo].sobremesa
            self.suco.text = cardapioDia[tipo].suco
            completionHandler(true)
        }
        
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
    
}
