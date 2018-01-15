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
    
    
    // - MARK: outlets jantar
    @IBOutlet weak var pratoPrincipalJantar: UILabel!
    @IBOutlet weak var sobremesaJantar: UILabel!
    @IBOutlet weak var sucoJantar: UILabel!
    @IBOutlet weak var guarnicaoJantar: UILabel!
    @IBOutlet weak var ptsJantar: UILabel!
    @IBOutlet weak var saladaJantar: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var diaDaSemanaLabel: UILabel!
    
    var errorUpdating: Bool = false
    
    @IBOutlet weak var errorRow: UITableViewCell!
    
    static let storyboardIdentifier = "CardapioTableView"
    
    @IBOutlet weak var viewAlmoco: UIView!
    @IBOutlet weak var viewJantar: UIView!
    
    @IBOutlet weak var vegetarianoButton: UIButton!
    var cardapio: Cardapio!
    var vegetariano: Bool! = false
    
    var screenshotAlmoco: Bool = true

    var parentPageViewController:PageViewController!
    
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
        
    }
    
    @IBAction func vegetarianoChanged(_ sender: Any) {
        self.parentPageViewController.vegetariano = !(self.parentPageViewController.vegetariano)
        
        if self.parentPageViewController.vegetariano {
            //Vegetariano
        } else {
            //Tradicional
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
    
    
    
//    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        if let oldViewFrame = tableView.footerView(forSection: section)?.frame {
//            let returnedView = UIView(frame: CGRect(origin: oldViewFrame.origin, size: oldViewFrame.size))
//            returnedView.backgroundColor = UIColor.clear
//            return returnedView
//        } else {
//            print("No footer background view")
//            return tableView.footerView(forSection: section)
//        }
//    }
//
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if let oldViewFrame = tableView.headerView(forSection: section)?.frame {
//            let returnedView = UIView(frame: CGRect(origin: oldViewFrame.origin, size: oldViewFrame.size))
//            returnedView.backgroundColor = UIColor.clear
//            return returnedView
//        } else {
//            print("No header background view")
//            return tableView.headerView(forSection: section)
//        }
//    }
    
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        if self.errorUpdating {
            tableView.reloadData()
        }
    }

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if cardapio != nil && vegetariano != nil {
            setCardapio(cardapio: self.cardapio, vegetariano: self.vegetariano)
        } else {
            print("Problema carregado view controller!")
        }
        
//        //Adicionando cantos arredondados as views de cardapio
//        self.viewAlmoco.layer.cornerRadius = 8.0
//        self.viewJantar.layer.cornerRadius = 8.0
        // Adicionando cantos arredondados as views de cardapio
        viewAlmoco.layer.cornerRadius = 20.0
        viewJantar.layer.cornerRadius = 20.0
        
        // Adicionando sombras aos cards
//        viewAlmoco.layer.shadowColor = UIColor.black.cgColor
//        viewAlmoco.layer.shadowOpacity = 1
//        viewAlmoco.layer.shadowOffset = CGSize.zero
//        viewAlmoco.layer.shadowRadius = 8.0
        
        let almocoShadowPath = UIBezierPath(rect: viewAlmoco.bounds)
        viewAlmoco.layer.masksToBounds = false
        viewAlmoco.layer.shadowColor = UIColor.black.cgColor
        viewAlmoco.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        viewAlmoco.layer.shadowOpacity = 0.5
        viewAlmoco.layer.shadowRadius = 8.0
        viewAlmoco.layer.shadowPath = almocoShadowPath.cgPath
        
        let jantarShadowPath = UIBezierPath(rect: viewJantar.bounds)
        viewJantar.layer.masksToBounds = false
        viewJantar.layer.shadowColor = UIColor.black.cgColor
        viewJantar.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        viewJantar.layer.shadowOpacity = 0.5
        viewJantar.layer.shadowRadius = 8.0
        viewJantar.layer.shadowPath = jantarShadowPath.cgPath
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackScreenView()
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
//        return "\(DIAS_DA_SEMANA[diaDiaSemana > 0 ? diaDiaSemana-1 : 6]), \(dia) de \(MESES[mes > 0 ? mes-1 : 11])"
    }

    //Sorry for the magical number :( 
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0) {
            return errorUpdating ? 30.0 : 2
        } else {
            return 45.0
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension CardapioTableViewController: ScreenshotDelegate {
    func screenshot() -> UIImage{
        var image = UIImage();
        UIGraphicsBeginImageContextWithOptions(self.tableView.contentSize, false, UIScreen.main.scale)
        
        // save initial values
        let savedContentOffset = self.tableView.contentOffset;
        let savedFrame = self.tableView.frame;
        let savedBackgroundColor = self.tableView.backgroundColor
        
        // reset offset to top left point
        self.tableView.contentOffset = CGPoint(x: 0, y: 0);
        // set frame to content size
        self.tableView.frame = CGRect(x: 0, y: 0, width: self.tableView.contentSize.width, height: self.tableView.contentSize.height);
        // remove background
        self.tableView.backgroundColor = UIColor.clear
        
        // make temp view with scroll view content size
        // a workaround for issue when image on ipad was drawn incorrectly
        let tempView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.contentSize.width, height: self.tableView.contentSize.height));
        
        let cardapioStoryBoard = UIStoryboard.init(name: "Share", bundle: nil)
        
        // instancia a view de Share
        let shareView = cardapioStoryBoard.instantiateViewController(withIdentifier: "ShareViewController") as? ShareTableViewController
        
        
        shareView?.cardapio = cardapio
        shareView?.vegetariano = vegetariano
        shareView?.screenshotAlmoco = self.screenshotAlmoco
        
        // save superview
        let tempSuperView = self.tableView.superview
        // remove scrollView from old superview
        self.tableView.removeFromSuperview()
        // and add to tempView
        //tempView.addSubview(self.tableView)
        tempView.addSubview((shareView?.view)!)
        
        // render view
        // drawViewHierarchyInRect not working correctly
        tempView.layer.render(in: UIGraphicsGetCurrentContext()!)
        // and get image
        image = UIGraphicsGetImageFromCurrentImageContext()!;
        
        // and return everything back
        tempView.subviews[0].removeFromSuperview()
        tempSuperView?.addSubview(self.tableView)
        
        // restore saved settings
        self.tableView.contentOffset = savedContentOffset;
        self.tableView.frame = savedFrame;
        self.tableView.backgroundColor = savedBackgroundColor
        
        var sizeToCrop = CGSize.zero

        if let footer = shareView!.footer
        {
            sizeToCrop = CGSize(width: footer.frame.width, height: footer.frame.origin.y)
        }
        
        
        UIGraphicsEndImageContext();
        
        let scale = UIScreen.main.scale
        
        /// PROTEGER O CÓDIGO. SEM FORCE UNWRAP
        image = UIImage(cgImage:(image.cgImage?.cropping(to: CGRect(x: 0, y: 0, width: sizeToCrop.width * scale , height: sizeToCrop.height * scale))!)!)
        
        return image
    }
}
