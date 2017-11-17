//
//  CardapioTableViewController.swift
//  BandecoUnicamp
//
//  Created by Gustavo Avena on 24/07/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit

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
    
    var errorUpdating: Bool = false {
        didSet {
            self.tableView.reloadData()
            print("Reloading tableView in CardapioTableViewController")
        }
    }
    @IBOutlet weak var errorRow: UITableViewCell!
    
    static let storyboardIdentifier = "CardapioTableView"
    
    var cardapio: Cardapio!
    var vegetariano: Bool! = false
    
    var screenshotAlmoco: Bool = true
    
    func setCardapio(cardapio: Cardapio, vegetariano: Bool) {
        
        self.cardapio = cardapio
        self.dateLabel.text = formatDateString(data: cardapio.data)
        
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0) {
            return errorUpdating ? 1 : 0
        } else {
            return 6
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if cardapio != nil && vegetariano != nil {
            setCardapio(cardapio: self.cardapio, vegetariano: self.vegetariano)
        } else {
            print("Problema carregado view controller!")
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackScreenView()
    }
    
    func formatDateString(data: Date) -> String {
        
        let DIAS_DA_SEMANA: [String] = ["Domingo", "Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado"]
        let MESES: [String] = ["Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"]
        
        let dia = Calendar.current.component(.day, from: data)
        let mes = Calendar.current.component(.month, from: data)
        let diaDiaSemana = Calendar.current.component(.weekday, from: data)
        
        // TODO: consertar isso! Muita gambiarra aqui... Usar dateFormatter e Locale.
        return "\(DIAS_DA_SEMANA[diaDiaSemana > 0 ? diaDiaSemana-1 : 6]), \(dia) de \(MESES[mes > 0 ? mes-1 : 11])"
    }

    //Sorry for the magical number :( 
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 30.0
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
