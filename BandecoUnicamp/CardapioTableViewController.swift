//
//  CardapioTableViewController.swift
//  BandecoUnicamp
//
//  Created by Gustavo Avena on 24/07/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit

protocol DietaChanged{
    func tipoDeDietaChanged()
}

class CardapioTableViewController: UITableViewController {

    // - MARK: outlets almoco
    @IBOutlet weak var pratoPrincipalAlmoco: UILabel!
    @IBOutlet weak var sobremesaAlmoco: UILabel!
    @IBOutlet weak var sucoAlmoco: UILabel!
    @IBOutlet weak var guarnicaoAlmoco: UILabel!
    @IBOutlet weak var ptsAlmoco: UILabel!
    @IBOutlet weak var saladaAlmoco: UILabel!
    @IBOutlet weak var viewAlmoco: UIView!
    @IBOutlet weak var almocoLabel: UILabel!
    
    
    // - MARK: outlets jantar
    @IBOutlet weak var pratoPrincipalJantar: UILabel!
    @IBOutlet weak var sobremesaJantar: UILabel!
    @IBOutlet weak var sucoJantar: UILabel!
    @IBOutlet weak var guarnicaoJantar: UILabel!
    @IBOutlet weak var ptsJantar: UILabel!
    @IBOutlet weak var saladaJantar: UILabel!
    @IBOutlet weak var viewJantar: UIView!
    @IBOutlet weak var jantarLabel: UILabel!
    
    // - MARK: outros outlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var diaDaSemanaLabel: UILabel!
    @IBOutlet weak var vegetarianoButton: UIButton!
    @IBOutlet weak var errorRow: UITableViewCell!
    
    // - MARK: outras variaveis e constantes
    var errorUpdating: Bool = false
    var cardapio: Cardapio!
    var vegetariano: Bool! = false
    var parentPageViewController:PageViewController!
    static let storyboardIdentifier = "CardapioTableView"
    
    
    
    
    // MARK: metodos de View Controller.
    
    override func viewWillAppear(_ animated: Bool) {
        if self.errorUpdating {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if cardapio != nil && vegetariano != nil {
            setCardapio(cardapio: self.cardapio, vegetariano: self.vegetariano)
            tableView.reloadData()
        } else {
            print("Problema carregado view controller!")
        }
        
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
        //         Adicionando cantos arredondados as views de cardapio
        viewAlmoco.layer.cornerRadius = 20.0
        viewJantar.layer.cornerRadius = 20.0
        
        viewAlmoco.layer.masksToBounds = false
        viewAlmoco.layer.shadowColor = UIColor.black.cgColor
        viewAlmoco.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        viewAlmoco.layer.shadowOpacity = 0.2
        viewAlmoco.layer.shadowRadius = 7.0
        
        viewJantar.layer.masksToBounds = false
        viewJantar.layer.shadowColor = UIColor.black.cgColor
        viewJantar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        viewJantar.layer.shadowOpacity = 0.2
        viewJantar.layer.shadowRadius = 7.0
        
        //        almocoShareButton.setImage(UIImage(named: "actionIcon"), for: .normal)
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackScreenView()
        
    }
    
    // MARK: metodos relacionados a conteudo e do cardapio.
    
    
    func setCardapio(cardapio: Cardapio, vegetariano: Bool) {
        
        self.cardapio = cardapio
        self.dateLabel.text = formatarData(data: cardapio.data)
        self.diaDaSemanaLabel.text = formatarDiaDaSemana(data: cardapio.data)
        
        let almoco = vegetariano ? cardapio.almocoVegetariano : cardapio.almoco
        let jantar = vegetariano ? cardapio.jantarVegetariano : cardapio.jantar
        
        
        pratoPrincipalAlmoco.text = almoco.pratoPrincipal
        sobremesaAlmoco.text = almoco.sobremesa
        sucoAlmoco.text = almoco.suco
        guarnicaoAlmoco.text = almoco.guarnicao
        ptsAlmoco.text = almoco.pts
        saladaAlmoco.text = almoco.salada
        
        
        pratoPrincipalJantar.text = jantar.pratoPrincipal
        sobremesaJantar.text = jantar.sobremesa
        sucoJantar.text = jantar.suco
        guarnicaoJantar.text = jantar.guarnicao
        ptsJantar.text = jantar.pts
        saladaJantar.text = jantar.salada
        
        // Seta o icone de vegetariano
        let image = vegetariano ? UIImage(named: "leafIconEnabled") : UIImage(named: "leafIconDisabled")
        vegetarianoButton.setImage(image, for: .normal)
        
        almocoLabel.text =  vegetariano ? "Almoço Vegetariano" : "Almoço"
        jantarLabel.text =  vegetariano ? "Jantar Vegetariano" : "Jantar"
    }
    
    @IBAction func vegetarianoChanged(_ sender: Any) {
        self.parentPageViewController.vegetariano = !(self.parentPageViewController.vegetariano)
    }
    
    fileprivate func presentActivityExtension(_ screenshot: UIImage) {
        let activityVC = UIActivityViewController(activityItems: [screenshot], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        
        // exclui opcao de "save image"
        activityVC.excludedActivityTypes = [UIActivityType.saveToCameraRoll]
        
        self.present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func shareAlmoco(_ sender: Any) {
        let screenshot = self.takeScreenshot(almoco: true)
        presentActivityExtension(screenshot)
    }
    

    @IBAction func shareJantar(_ sender: Any) {
        let screenshot = self.takeScreenshot(almoco: false)
        presentActivityExtension(screenshot)
    }
    

    func formatarDiaDaSemana(data: Date) -> String {
        let DIAS_DA_SEMANA: [String] = ["Domingo", "Segunda-Feira", "Terça-Feira", "Quarta-Feira", "Quinta-Feira", "Sexta-Feira", "Sábado"]
        
        let diaDiaSemana = Calendar.current.component(.weekday, from: data)
        
        return DIAS_DA_SEMANA[diaDiaSemana > 0 ? diaDiaSemana-1 : 6]
    }
    
    func formatarData(data: Date) -> String {
        
        
        let MESES: [String] = ["Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"]
        
        let dia = Calendar.current.component(.day, from: data)
        let mes = Calendar.current.component(.month, from: data)
        
        
        // TODO: consertar isso! Muita gambiarra aqui... Usar dateFormatter e Locale.
        return "\(dia) de \(MESES[mes > 0 ? mes-1 : 11])"
    }
    
    // MARK: metodos da TableView.

    //Sorry for the magical number :( 
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0) {
            return errorUpdating ? 30.0 : 2
        } else {
            return 15.0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 1:
            return cardapio!.almoco.observacoes
        case 2:
            return cardapio!.jantar.observacoes
        default:
            //            print("Problema setando o footer das sections na Table View.")
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor.clear
    }
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor.clear
    }
    
    
    
    // CRASH AQUI
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0) {
            return errorUpdating ? 1 : 0
        } else {
            return 1 // Tava crashando o app.
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if(section == 0) {
            return errorUpdating ? UITableViewAutomaticDimension : 0.01
        } else {
            return UITableViewAutomaticDimension
        }
    }
}

extension UIViewController {
    func trackScreenView() {
        if let tracker = GAI.sharedInstance().defaultTracker {
            tracker.set(kGAIScreenName, value: NSStringFromClass(type(of: self)))
            tracker.send(GAIDictionaryBuilder.createScreenView().build() as! [AnyHashable : Any]!)
        }
    }
}


// TODO: resolver crash que ocorre quando o usuario tenta SALVAR o screenshot.

// - MARK: metodos para o screenshot
extension CardapioTableViewController {

    func takeScreenshot(almoco: Bool) -> UIImage {
        var image:UIImage = UIImage()
        
        // Almoco é section 1 e jantar é section 2.
        

        let indexPath = IndexPath(row: 0, section: almoco ? 1 : 2)
        
//        print("Section = \(section)")
        if self.tableView.cellForRow(at: indexPath) == nil {
            print("Couldn't get table view cell for share extension!")
        }
        
        let cell = self.tableView.cellForRow(at: indexPath) ?? tableView.visibleCells[0]
        
        UIGraphicsBeginImageContextWithOptions(cell.bounds.size, cell.isOpaque, 0.0)
        defer { UIGraphicsEndImageContext() }
        if let context = UIGraphicsGetCurrentContext() {
            cell.layer.backgroundColor = UIColor.groupTableViewBackground.cgColor
            cell.layer.render(in: context)
            
            image = UIGraphicsGetImageFromCurrentImageContext()!
        }
        
        return image
    }
}
