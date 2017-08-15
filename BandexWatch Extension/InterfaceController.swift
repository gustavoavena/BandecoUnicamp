//
//  InterfaceController.swift
//  BandexWatch Extension
//
//  Created by Gustavo Avena on 12/08/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import WatchKit
import Foundation

class PratoPrincipalRow: NSObject {
    @IBOutlet var pratoPrincipal: WKInterfaceLabel!
}

class SobremesaRow: NSObject {
    @IBOutlet var sobremesa: WKInterfaceLabel!
    @IBOutlet var sobremesaImage: WKInterfaceImage!
}


class SucoRow: NSObject {
    @IBOutlet var suco: WKInterfaceLabel!
    @IBOutlet var sucoImage: WKInterfaceImage!
}


class InterfaceController: WKInterfaceController {

  
    @IBOutlet var table: WKInterfaceTable!
    
    @IBOutlet var refeicaoLabel: WKInterfaceLabel!
    @IBOutlet var dataLabel: WKInterfaceLabel!
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        let cardapios = CardapioServices.getAllCardapios()
        
        let numeroCardapio = cardapioProxDia() ? 1 : 0
        
        guard cardapios.count > numeroCardapio else {
            print("nao veio nenhum cardapio.")
            return
        }
        
        
//        for type in rowTypes {
//            table.setNumberOfRows(1, withRowType: type)
//        }
        
        let cardapioDia = cardapios[numeroCardapio]
        
        print(cardapioDia.data)
        
        let tipo = self.getTipoRefeicaoParaExibir(dataCardapio: cardapioDia.data)
        
        setCardapioValues(refeicao: cardapioDia[tipo], data: cardapioDia.data)
       
        
        
        
        

    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    // - MARK: copia do widget
    
    func setCardapioValues(refeicao: Refeicao, data: Date) {
        print("Temos o cardapio!")
        
        let rowTypes = ["pratoPrincipalRow", "sobremesaRow", "sucoRow"]
        table.setRowTypes(rowTypes)
        
        guard let ppRow = table.rowController(at: 0) as? PratoPrincipalRow,
            let sobremesaRow = table.rowController(at: 1) as? SobremesaRow,
            let sucoRow = table.rowController(at: 2) as? SucoRow else {
                print("Erro ao carregar as rows!")
                return
        }
        
        ppRow.pratoPrincipal.setText(refeicao.pratoPrincipal)
        sobremesaRow.sobremesa.setText(refeicao.sobremesa)
        sobremesaRow.sobremesaImage.setImage(UIImage(named: "sobremesa1"))
        sobremesaRow.sobremesaImage.setWidth(30.0)
        sobremesaRow.sobremesaImage.setHeight(30.0)
        sucoRow.suco.setText(refeicao.suco)
        sucoRow.sucoImage.setImage(UIImage(named: "suco"))
        
        refeicaoLabel.setText(refeicao.tipo.rawValue)
        dataLabel.setText(formatDateString(data: data))
    }

    private func formatDateString(data: Date) -> String {
        
        let DIAS_DA_SEMANA: [String] = ["Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sab"]
        
        let dia = Calendar.current.component(.day, from: data)
        let mes = Calendar.current.component(.month, from: data)
        let diaDiaSemana = Calendar.current.component(.weekday, from: data)
        
        // TODO: consertar isso! Muita gambiarra aqui... Usar dateFormatter e Locale.
        return "\(DIAS_DA_SEMANA[diaDiaSemana > 0 ? diaDiaSemana-1 : 6]) - \(dia)/\(mes+1)"
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
    
    func cardapioProxDia() -> Bool {
        let hora = Calendar.current.component(.hour, from: Date())
        let weekday = Calendar.current.component(.weekday, from: Date())
        
        return (hora > 19) && (2...6).contains(weekday) ? true : false
    }



}
