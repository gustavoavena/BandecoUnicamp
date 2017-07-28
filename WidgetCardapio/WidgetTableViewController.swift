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
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    func widgetSizeChanged(expanded: Bool) {
        guarnicaoCell.isHidden = !expanded
        guarnicao.isHidden = !expanded
        saladaCell.isHidden = !expanded
        salada.isHidden = !expanded
        ptsCell.isHidden = !expanded
        pts.isHidden = !expanded
    }
    
    func displayError() {
        let errorString = "Desculpe, não foi possível carregar o cardápio."
        pratoPrincipal.adjustsFontSizeToFitWidth = true
        pratoPrincipal.textColor = UIColor.red
        setCardapioValues(refeicao: "", pratoPrincipal: errorString, sobremesa: "", suco: "", guarnicao: "", salada: "", pts: "", data: Date())
    }
    
    func setCardapioValues(refeicao: String, pratoPrincipal: String, sobremesa: String, suco: String, guarnicao: String, salada: String, pts: String, data: Date) {
        self.refeicao.text = refeicao
        self.pratoPrincipal.text = pratoPrincipal
        self.sobremesa.text = sobremesa
        self.suco.text = suco
        self.guarnicao.text = guarnicao
        self.salada.text = salada
        self.pts.text = pts
        self.dataLabel.text = formatDateString(data: data)
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
    

}
