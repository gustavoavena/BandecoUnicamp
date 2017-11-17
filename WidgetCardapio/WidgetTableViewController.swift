//
//  WidgetTableViewController.swift
//  BandecoUnicamp
//
//  Created by Gustavo Avena on 27/07/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit

class WidgetTableViewController: UITableViewController {
    
    @IBOutlet weak var refeicao: UILabel!
    @IBOutlet weak var pratoPrincipal: UILabel!
    @IBOutlet weak var sobremesa: UILabel!
    @IBOutlet weak var suco: UILabel!
    @IBOutlet weak var guarnicao: UILabel!
    @IBOutlet weak var salada: UILabel!
    @IBOutlet weak var pts: UILabel!
    @IBOutlet weak var guarnicaoCell: UITableViewCell!
    @IBOutlet weak var saladaCell: UITableViewCell!
    @IBOutlet weak var ptsCell: UITableViewCell!
    @IBOutlet weak var dataLabel: UILabel!
    
    
    @IBOutlet weak var pratoPrincipallCell: UITableViewCell!
    @IBOutlet weak var sobremesaCell: UITableViewCell!
    @IBOutlet weak var sucoCell: UITableViewCell!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func displayError() {
        if let d = UserDefaults.standard.dictionary(forKey: "lastRefeicaoWidget") {
            setCardapioValues(from: d)
        }
        
        let errorString = "Erro ao atualizar cardápio"
        self.refeicao.textColor = UIColor.red
        self.refeicao.adjustsFontSizeToFitWidth =  true
        self.refeicao.text = errorString
    }
    

    func storeDictionary(refeicao: Refeicao, data: Date) {
        var d = [String: Any]()
        
        d["refeicao"] = refeicao.tipo.rawValue
        d["pratoPrincipal"] = refeicao.pratoPrincipal
        d["sobremesa"] = refeicao.sobremesa
        d["suco"] = refeicao.suco
        d["guarnicao"] = refeicao.guarnicao
        d["salada"] = refeicao.salada
        d["pts"] = refeicao.pts
        d["dataLabel"] = formatDateString(data: data)
        
        UserDefaults.standard.set(d, forKey: "lastRefeicaoWidget")
    }
    
    
    func setCardapioValues(refeicao: Refeicao, data: Date) {
        self.refeicao.textColor = UIColor.darkGray
        self.refeicao.text = refeicao.tipo.rawValue
        self.pratoPrincipal.text = refeicao.pratoPrincipal
        self.sobremesa.text = refeicao.sobremesa
        self.suco.text = refeicao.suco
        self.guarnicao.text = refeicao.guarnicao
        self.salada.text = refeicao.salada
        self.pts.text = refeicao.pts
        self.dataLabel.text = formatDateString(data: data)
        
        storeDictionary(refeicao: refeicao, data: data)
    }
    
    func setCardapioValues(from d: [String: Any]) {
        
        self.pratoPrincipal.text = d["pratoPrincipal"] as? String
        self.sobremesa.text = d["sobremesa"] as? String
        self.suco.text = d["suco"] as? String
        self.guarnicao.text = d["guarnicao"] as? String
        self.salada.text = d["salada"] as? String
        self.pts.text = d["pts"] as? String
        self.dataLabel.text = d["dataLabel"] as? String
    }
    
    private func formatDateString(data: Date) -> String {
        
        let DIAS_DA_SEMANA: [String] = ["Domingo", "Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado"]
        let MESES: [String] = ["Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"]
        
        let dia = Calendar.current.component(.day, from: data)
        let mes = Calendar.current.component(.month, from: data)
        let diaDiaSemana = Calendar.current.component(.weekday, from: data)
        
        // TODO: consertar isso! Muita gambiarra aqui... Usar dateFormatter e Locale.
        return "\(DIAS_DA_SEMANA[diaDiaSemana > 0 ? diaDiaSemana-1 : 6]), \(dia) de \(MESES[mes > 0 ? mes-1 : 11])"
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        extensionContext?.open(URL(string: "Bandex://")!, completionHandler: { (success) in
            if (!success) {
                print("error")
            }
        })
    }
    
    
}
